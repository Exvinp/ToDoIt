//
//  ViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    
    // opcionális, nincs értéke, de ahogy értéket kap a didSet-ben lévő utasítások lefutnak
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    //ezzel a kóddal az AppDelegate classból csinálunk egy singleton(.shared miatt) object-et, persistentContainer property-jének viewContext porperty-je
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
//MARK: - Tableview Datasource Methods ////////////////////////////////////////////////////////////
    // feltölti a tableView-t a tömb elemeivel
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    
    
//MARK: - Tableview Delegate Methods //////////////////////////////////////////////////////////////
    //akkor fut le amikor egy sort kiválasztunk
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //törlés, az első a DB-ből törli, a második a tableview-ból, fontos a sorrend!!!!
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        //ha a kiválasztott sor done-ja false (nincs pipa) akkor rakja ki a pipát, és fordítva
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //amikor kiválasztjuk a sort, akkor egyből deselect-álódik és eltünik a szürke kijelölés
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
//MARK: - Add New Items //////////////////////////////////////////////////////////////////////////////////
    //akkor fut le amikor a hozzáadás gomb (plusz jel) pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //ez az a szöveg amit a user beír hogy hozzáadódjon a listához
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoIt Item", message: "", preferredStyle: .alert)
        
        //itt adjuk hozzá a gombot
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //ez fog történni amikor a user ráklikkel az "Add Item" gombra
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        //ez egy closure, az alertTextField egy ideiglenes változó benne amit mi hozunk létre
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        //itt adjuk hozzá az alert felugró ablakhoz az action gombot
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
    
//MARK: - Model Manipulation Methods ///////////////////////////////////////////////////////////////
    
    func saveItems(){
        do {
            try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    
//TODO: loadItems()!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //with külső paraméter, request a belső paraméter
    //ha a request paraméter nincs megadva a híváskor akkor az alapértelmezett értéke az Item DB fetchRequest() metódusa
    //NSPredicate: a lekérdezés típusa
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //optional binding, csak akkor fut le ha a loadItems meghívásakor predicate paraméter nem nil
        //ebben az esetben egy kombinált lekérdezés megy vége, azaz egy kategórián belül keresünk Itme-re
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            //ha nil az értéke akkor a kategóriákat kell lekérdezni, azaz a request object predicate properiy-jének értéke a kategória neve lesz
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        
        do{
            //ez maga a lekérdezés
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }


}



//MARK: - Search bar methods ////////////////////////////////////////////////////////////////////////////
extension ToDoListViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //a request object típusa NSFetchRequest<Item>, az Item DB fetchRequest()-jét hívja meg
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        

        //lekérdezés object, NSPredicate fv, title-ben keressük, CONTAINS = tartalmazza, [cd] nem case(Aa) és diacritic(aá) sensitive, %@ amit keresünk
        //searchBar.text ahonnan jön amit keresünk
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        //sorting (rendezés), titile szerint, abc sorrendben
        //let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        //
        //egy array-t vár el a sortDescriptors, ezért egy single array-t kap amiben a sortDescriptr van, de ezt a kettő utasítást egyben is meg lehet adni
        //request.sortDescriptors = [sortDescriptr]
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

    }
    
    
    //akkor amikor a searchBar-ban lévő elemek száma 0-ra változik (azaz nem betöltéskor) akkor vissza viszi a user-t
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            //a DispatchQueue az aktív eszközök kikapcsolását szabályozó rendszer, különböző thread-ekbe tudja sorolni a folyamatot
            //mia main thread-be akarjuk kinyirnia billentyűt (hogy gyors legyen)
            DispatchQueue.main.async {
                //megszünik fő beszélőnek lenni
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
}















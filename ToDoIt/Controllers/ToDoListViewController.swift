//
//  ViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //object tömb: olyan object amiben tömbök vannak, és azok a tömbök is object-ek
    //tömb object: olyan tömb ami object, de minden tömb object ezért enek nincs értelme

    //a todoItems egy object-ekből álló tömb lesz, ami lehet nil is
    //a Realm RUD műveletek Result típusú konténerrel (object) térnek vissza, a konténer az Item tábla felépítését követi
    //a műveletek végén az Item táblában lévő rekordokból képzett object-eket fogja tárolni
    var todoItems: Results<Item>?
    
    //a Realm class object-je a realm, ez egy új access point a Realm DB-hez
    var realm = try! Realm()
    
    //a CategoryView-ban kiválasztott kategória elemet mint object-et tartalmazza a selectedCategory
    var selectedCategory: Category?{
        //opcionális, nincs értéke(Category?), de ahogy értéket kap a didSet-ben lévő utasítások lefutnak
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
//MARK: - Tableview Datasource Methods ////////////////////////////////////////////////////////////
    
    //megadja hány sornak kell lennie a TableView-ban, azaz beállítja a cellForRowAt-nak az i-t ([indexPath.row]), hogy hányszor kell lefutnia, azaz hányszor kell cellát generálnia
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing operator, visszaadja az item-ek számát (= a kategóriában hány feladat van), ha nil az értéke akkor 1-t ad vissza
        return todoItems?.count ?? 1
    }
   
    
    //a cellákat egyesével feltölti
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //létrehoz egy újrafelhasználható cellát aminek az azonosítója ToDoItemCell ami a TableView-hoz köti
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //ha van item object a todoItems object tömbben ([indexPath.row] = i, tehát nem nil), akkor az i-ediket hozzárendeli az item object-hez
        if let item = todoItems?[indexPath.row]{
            
            //a cellának megadja text-nek a title-t
            cell.textLabel?.text = item.title
            
            //a cella accessoryType-ja egy pipát kap ha az elem done property-je igaz, ha nem igaz akkor semmit (.none) Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            
            //ha nincs item object a todoItems object tömbben, akkor a numberOfRowsInSection miatt csak egyszer fut le
            //és így annak az egy létrejött cellának a szövege az lesz, hogy No Items Added
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }

    
    
//MARK: - Tableview Delegate Methods //////////////////////////////////////////////////////////////
    
    //akkor fut le amikor egy sort kiválasztunk
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //ha a sor amire ráklikkeltünk egy feladat (tehát nem a "No Items Added" cella), akkor a feladat object-je betöltődik az otem object-be
        if let item = todoItems?[indexPath.row]{
            do{
                //a write utasítással tudjuk a RUD műveleteket előkészíteni (read, update, destroy)
                try realm.write{
                    
                    //az object done property-jének értékét megváltoztatja az ellenkezőjére (true/false)
                    item.done = !item.done
                    
                    //törli az adott kiválasztott itemet
                    //realm.delete(item)
                }
            }catch{
                print("Error saving done status \(error)")
            }
            
        }
        //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
        tableView.reloadData()
        
        //amikor ráklikkelünk a sorra akkor az utasítások végén deselect-álja (eltünteti a kijelölést)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
//MARK: - Add New Items //////////////////////////////////////////////////////////////////////////////////
    
    //akkor fut le amikor a hozzáadás gombot (plusz jel) megnyomjuk
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //ez az a szöveg amit a user beír hogy hozzáadódjon a listához
        var textField = UITextField()
        
        //ez a felugró ablak címét, és stílusát határozza meg
        let alert = UIAlertController(title: "Add New ToDoIt Item", message: "", preferredStyle: .alert)
        
        //add gomb szövege és stílusa
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //ez fog történni amikor a user ráklikkel az "Add Item" gombra, ez egy closure (fv a UIAlertAction fv-ben)
            
            //amikor a user ráklikkel az "Add Item" gombra megnézzük, hogy ki van-e választva kategória object,
            //mert ha nincs akkor a hozzáadott item-et (feladatot) nem tudjuk kategóriához kötni,
            //ha nem nil akkor a currentCategory objectnek adjuk át a kiválasztott kategória object-et
            if let currentCategory = self.selectedCategory{
                
                do{
                    //megpróbál hozzáférni a DB-hez
                    try self.realm.write{
                        
                        //létrehoz egy új object-et aminek a típusa az Item tábla felépítését kapja, mert az Item() class a szülője
                        let newItem = Item()
                        
                        //az új object titel-je a beírt szöveg lesz
                        newItem.title = textField.text!
                        
                        //az új object dateCreated property-jének értéke a létrehozás dátuma
                        newItem.dateCreated = Date()
                        
                        //a kiválasztott kategória object, items object tömb-jéhez adja hozzá az append-el az új object-et (newItem)
                        //az items egy olyan object(a kategóriához tartozó feladat) amiben a rekordok(feladat neve, létrehozásának ideje) object-ként szerepelnek
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new Item, \(error)")
                }
            }
            
            //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
            self.tableView.reloadData()
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

    func loadItems(){
        //a todoItems tömböt feltölti a selectedCategory object items object-jeivel
        //gyakorlatilag egy objectet(todoItems) tölt fel egy másik object-ben(selectedCategory) lévő object-ekkel(items), és rendezi őket nevük (title) szerint abc sorrendbe
        //a selectedCategory-ban lévő items gyakorlatilag csak egy reference az Item tábla azon rekordjaira amik az adott selectedCategory-hoz kapcsolódnak, a rekordokból object-ek lesznek
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
        tableView.reloadData()
    }


}



//MARK: - Search bar methods ////////////////////////////////////////////////////////////////////////////

extension ToDoListViewController: UISearchBarDelegate{

    //akkor fut le amikor a search gombra klikkelünk
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //a todoItems object object-jeinek titlte property értékeit szűri (filter)
        //hogy tartalmazzák-e (CONTAINS[cd]) [c]case(Aa) és [d]diacritic(aá) insensitive-en (ezektől függetlenül)
        //a keresett kifejezést (%@), aminek a forrását a második paraméter adja meg (searchBar.text!)
        //az eredményeket rendezi (sort) az objectek dateCreated property-je szerint
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
        tableView.reloadData()
    }


    //akkor aktiválódik amikor a serachBar karaktereinek száma változik (de betöltődéskor nem aktiválódik amikor nil-ból 1 lesz)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //ha a serachBar karaktereinek száma x-ről 0-ra vált (kitröljük őket, vagy rányomunk az X-re oldalt)
        if searchBar.text?.count == 0{
            
            //újratöltjük az elemeket
            loadItems()

            //a DispatchQueue az aktív eszközök kikapcsolását szabályozó rendszer, különböző thread-ekbe tudja sorolni a folyamatot
            //mi a main thread-be akarjuk kinyirni a folyamatot hogy gyors legyen
            DispatchQueue.main.async {
                
                //a searchBar megszünik fő beszélőnek lenni, eltünik róla a focus, és a billentyű
                searchBar.resignFirstResponder()
            }
        }
    }




}















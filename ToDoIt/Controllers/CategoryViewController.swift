//
//  CategoryViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 05..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: UITableViewController {
    
    //a Realm class object-je a realm, ez egy új access point a Realm DB-hez
    let realm = try! Realm()
    
    //a categories egy object-ekből álló tömb lesz, ami lehet nil is
    //a Realm RUD műveletei Result típusú konténerrel (object) térnek vissza, a konténer a Category tábla felépítését követi
    //a műveletek végén a Category táblában lévő rekordokból képzett object-eket fogja tárolni
    var categories: Results<Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    

    
    
//MARK: - Tableview Datasource Methods ////////////////////////////////////////////////////////////
    
    //megadja hány sornak kell lennie a TableView-ban, azaz beállítja a cellForRowAt-nak az i-t ([indexPath.row]), hogy hányszor kell lefutnia, azaz hányszor kell cellát generálnia
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing operator, visszaadja a kategóriák számát, ha nil az értéke akkor 1-t ad vissza
        return categories?.count ?? 1
    }
    
    
    //a cellákat egyesével feltölti
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //létrehoz egy újrafelhasználható cellát aminek az azonosítója CategoryCell ami a TableView-hoz köti
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //ha a visszaadott categories object tömb i-edik (= [indexPath.row]) elemének neve üres akkor kapja hogy:"No Categories Added yet"
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
   
//MARK: - Data Manipulation Methods ///////////////////////////////////////////////////////////////
    
    //a category paraméter azlesz amit az addButtonPressed átad nekünk, hogy elmentsük
    func save(category: Category){
        
        do {
            //a write utasítással tudjuk a RUD műveleteket előkészíteni (read, update, destroy)
            try realm.write {
                //az add a realm beépített metódusa a CRUD szerint: update művelet, valójában: (hozzáadás/módosítás)
                realm.add(category)
            }
        }catch{
            print(error)
        }
        //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
        tableView.reloadData()
        
    }
    
    
    
    func loadCategories(){
        
        //a realm objects method-dal a Category táblában található összes rekordból Result típusú, Category felépítésű (megfelelő oszlopok) object-ek jönnek létre
        //amit megkap a categories tömb
        categories = realm.objects(Category.self)
        
        //a reloadData() fv automatikusan a Tableview Datasource Method-okat hívja meg, amik újratöltik cellákkal a tableView-t
        tableView.reloadData()
    }
    
    
    
//MARK: - Add new Categories //////////////////////////////////////////////////////////////////////
    
    //akkor fut le amikor a hozzáadás gombot (plusz jel) megnyomjuk
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //ez az a szöveg amit a user beír hogy hozzáadódjon a kategóriákhoz
        var textField = UITextField()
        
        //ez a felugró ablak címét, és stílusát határozza meg
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //add gomb szövege és stílusa
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //ez fog történni amikor a user ráklikkel az "Add" gombra, ez egy closure (fv a UIAlertAction fv-ben)
            
            //a newcategory egy object aminek a class-a a Category() -> Category.swift
            let newCategory = Category()
            
            //amit a user a textField-be beírt az lesz a name
            newCategory.name = textField.text!
            
            //meghívjuk a save metódust, hogy elmentse a DB-be
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create new Category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - Tableview Delegate Methods //////////////////////////////////////////////////////////////
    
    //akkor fut le amikor az egyik kategóriára klikkelünk, meghívja a Segue-t, hogy átvigyen minket a ToDoList-ba
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //ez fut le a Segue előtt
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //létrehozunk egy új példányt az érkezés helyének ViewController-éről
        let destinationVC = segue.destination as! ToDoListViewController
        
        //ha a kiválasztott sornak van értéke(tableView.indexPathForSelectedRow) akkor azt az értéket megkapja indexPath99
        if let indexPath99 = tableView.indexPathForSelectedRow{
            
            //a ToDoListViewController-ének selectedCategory property-je pedig
            //megkapja a kiválasztott kategóriát mint object-et a categories?[indexPath99.row]-al
            destinationVC.selectedCategory = categories?[indexPath99.row]
            
            //sorszam: print("indexPath99.row value: \(indexPath99.row)")
            //object: print("categories?[indexPath99.row] value: \(categories?[indexPath99.row])")
        }
        
    }
    
    

    
}

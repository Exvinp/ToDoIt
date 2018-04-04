//
//  ViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //ez egy array (ezért lehet .first) singleton object, itt hozzuk létre a Items.plist-et
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        print("\(itemArray[indexPath.row])")
        print("\(itemArray[indexPath.row].title)")
        
        //ha a kiválasztott sor done-ja false (nincs pipa) akkor rakja ki a pipát, és fordítva
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //amikor kiválasztjuk a sort, akkor egyből deselect-álódik és eltünik a szürke kijelölés
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
//MARK: - Add New Items ///////////////////////////////////////////////////////////////////////////////
    //akkor fut le amikor a hozzáadás gomb (plusz jel) pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //ez az a szöveg amit a user beír hogy hozzáadódjon a listához
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoIt Item", message: "", preferredStyle: .alert)
        
        //itt adjuk hozzá a gombot
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //ez fog történni amikor a user ráklikkel az "Add Item" gombra
            let newItem = Item()
            newItem.title = textField.text!
            
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
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


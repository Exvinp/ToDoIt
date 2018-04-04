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
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "CsineldEzt"
        itemArray.append(newItem)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        //ha a kiválasztott sor accessoryType-ja pipa akkor vegye ki a pipát, ha semmi akkor rakja oda
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.reloadData()
        
        //amikor kiválasztjk a sort, akkor egyből deselect-álódik és eltünik a szürke kijelölés
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
//MARK: - Add New Items //////////////////////////////////////////////////////////////////////////
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //ez az a szöveg amit a user beír hogy hozzáadódjon a listához
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoIt Item", message: "", preferredStyle: .alert)
        
        //itt adjuk hozzá a gombot
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //ez fog történni amikor a user ráklikkel az "Add Item" gombra
            //print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        //ez egy closure és az alertTextField egy ideiglenes változó benne amit mi hozunk létre
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        //itt adjuk hozzá az alert felugró ablakhoz az action gombot
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


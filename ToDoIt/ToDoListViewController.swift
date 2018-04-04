//
//  ViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Megcsinálni 1", "Megcsinálni 2", "Dodoit3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
//MARK: - Tableview Datasource Methods ////////////////////////////////////////////////////////////
    // feltölti a tableView-t a tömb elemeivel
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    
    
//MARK: - Tableview Delegate Methods //////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(itemArray[indexPath.row])")
        

        //ha a kiválasztott sor accessoryType-ja pipa akkor vegye ki a pipát, ha semmi akkor rakja oda
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
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


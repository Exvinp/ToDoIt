//
//  ViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Megcsinálni 1", "Megcsinálni 2", "Dodoit3"]
    
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

    
    
    

}


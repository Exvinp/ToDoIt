//
//  CategoryViewController.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 05..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit
import CoreData


//ez a ViewController ugyan arra az alapra épül mint a ToDoListViewController leszámítva azt hogy abban lehet keresni is, ezért kicsit át van alakítva
class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    //ezzel a kóddal az AppDelegate classból csinálunk egy object-et, persistentContainer property-jének viewContext porperty-je
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    

    
    
//MARK: - Tableview Datasource Methods ////////////////////////////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        return cell
    }
    
   
//MARK: - Data Manipulation Methods ///////////////////////////////////////////////////////////////
    func saveCategories(){
        
        do {
            try context.save()
        }catch{
            print(error)
        }

        tableView.reloadData()
        
    }
    
    
    func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
//MARK: - Add new Categories //////////////////////////////////////////////////////////////////////
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create new Category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - Tableview Delegate Methods //////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        //a tableView.indexPathForSelectedRow mutatja meg melyik az a sor ami ki van választva
        if let indexPath99 = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath99.row]
        }
        
    }
    
    

    
}

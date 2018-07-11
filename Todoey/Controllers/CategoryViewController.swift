//
//  CategoryViewController.swift
//  Todoey
//
//  Created by vishwajeet on 06/07/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    var categoryArray : Results<Category>?
    // results is a collection like array or list or dictionaries, and here it is like an array of category objects.
    
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    loadItems()
        
        tableView.rowHeight = 80.0
        
        
    }
    
    //MARK - TableView DataSource Methods
    
    // create cells and rows
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        // this means that if categoryArray is not nil then it will perform the count function but if it is nil (??)  then it will return 1, i.e. only one cell in the table will be there
        
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Nothing is added yet"
        cell.delegate = self
        
        return cell
        
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }    // we set our .selectedCategory to the category array row we selected.
        
    }
    
    
    
    
    //MARK - Data Manipulation Methods
    
    // save and load
    
    func save(category : Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data. \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadItems() {
        
        categoryArray = realm.objects(Category.self)
        // this will pull out all of the items inside our realm that are of category objects. the datatype of objects that we get back is Result<Category>.
        
    }
    
    
    
    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      //what happens when the add item button is pressed
            print("success")
            
        
        
        let newCategory = Category()
        
        newCategory.name = textfield.text!
        
        
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            
            alertTextField.placeholder = "Create New Category"
            
            textfield = alertTextField
            
        }
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
}


extension CategoryViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("item deleted")
            
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
            } catch {
                print("error deleting the category. \(error)")
            }
            
                tableView.reloadData()
            
                }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    
    
}









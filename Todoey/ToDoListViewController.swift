//
//  ViewController.swift
//  Todoey
//
//  Created by vishwajeet on 29/06/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [String]()
    
    let defaults = UserDefaults.standard
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
            
        }
        
    }

    //MARK - TableView DataSource Methods
    
    
    //first we declare the number of rows we need
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    //now this will make a cell for us, one cell at a time
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        //indexpath.row starts from 0 (as row begins from 0). hence our array will start from 0 index.
        // indexpath contains properties such as row and section. i.e. the location of the cell. 
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    //these are in built tableView delegate methods that we got because our superclass is tableViewController instead of simple UIViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        // here we say that when we click on this cell at this indexpath of our table view, we want an accessory type called checkmark
        
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }  else {
            
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
            
            
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "New ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print("success")
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            self.tableView.reloadData()
            
        }
        
       
            
            alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
                
                
                textField = alertTextField
            
               }
        
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
        
        
    }
    
}














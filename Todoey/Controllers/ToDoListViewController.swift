//
//  ViewController.swift
//  Todoey
//
//  Created by vishwajeet on 29/06/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    //array of objects of item instead of array of strings. objects that we make of the class item go into this array
    
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Get Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {

            itemArray = items  }
        
        
    }

    //MARK - TableView DataSource Methods
    
    
    //first we declare the number of rows we need
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
        
        
    }
    
    
    //now this will make a cell for us, one cell at a time
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        //we did this just to shorten the code, it is not compulsory
        
        cell.textLabel?.text = item.title
        
        // .title because our itemArray has objects stored in it, as it is an array of objects
        //indexpath.row starts from 0 (as row begins from 0). hence our array will start from 0 index.
        // indexpath contains properties such as row and section. i.e. the location of the cell.
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    //these are in built tableView delegate methods that we got because our superclass is tableViewController instead of simple UIViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // this means that if the value of .done is true, the value will become opposite and will be stored in .done on LHS
        //all this would happen when a particular row is selected
        
        
        tableView.reloadData()
        // as everytime we set the value of .done when we select the row, we send the data to cellForRowAt and tell them that if .done = true then .checkmark will be there. and this is checked for each cell in cellForRowAt. and we use reload to make it check and fulfill the conditions if required right after we set the .done value over here.
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        //after all the processes are done, this will deselect the row (i.e. remove the highlight on the row)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "New ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print("success")
            
            
            //here we will take a new object called newitem as we need to store the value of textfield.text into newItem.title so that we can put newItem into the array
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
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














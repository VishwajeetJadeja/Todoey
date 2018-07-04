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
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(dataFilePath)
        
        
        loadItems()
        
        
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
        

        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    //these are in built tableView delegate methods that we got because our superclass is tableViewController instead of simple UIViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // this means that if the value of .done is true, the value will become opposite and will be stored in .done on LHS
        //all this would happen when a particular row is selected as it is in the function didselectRowAt
        
        
        saveItems()
        
        
        
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
            
            self.saveItems()
            
            
                }
        
       
            
            alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
                
                
                textField = alertTextField
            
               }
        
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
        
        
    }
    
    //encode
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            
            print("Error encoding the data. \(error)")
            
        }
        
        self.tableView.reloadData()

        
    }
    
    
    //decode
    func loadItems() {
        
        let data = try? Data(contentsOf: dataFilePath!)
        let decode = PropertyListDecoder()
        
        do {
            itemArray = try decode.decode([Item].self, from: data!)
        } catch {
            print("Error decoding the data. \(error)")
        }
        
        // we write [Item] here because,  decode.decode is the method that is going to decode our data from the dataFilePath but we have to specify that what is the datatype of the thing that is going to be decoded and the datatype here is an array of [Item], and because we are not specifying objects, in order to refer to the type which is array of items, we have to write [Item].self
    }
    
}














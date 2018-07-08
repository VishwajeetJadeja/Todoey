//
//  ViewController.swift
//  Todoey
//
//  Created by vishwajeet on 29/06/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    //array of objects of item instead of array of strings. objects that we make of the class item go into this array
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //here we made appdelegate an object. and it has the property persistentContainer and we are grabbing viewContext of the persistentContainer
    
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
            
        }  //didSet means that the commands inside its curly brackets will run when an item is set in the selectedCategory property
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
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
        
        
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
        
        
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
            
            
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
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
    

    func saveItems() {
        
       
        
        do {
             try context.save()
            } catch {
                print("Error saving context. \(error)")
                    }
        
        self.tableView.reloadData()

        
    }
    
    
    //here we will give loadItems a default parameter, so if there is no input, it will take the default value into consideration
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        // if condition will run only if 'predicate' has some value i.e. that was passed as a parameter, else if no value was passed, it will be nil by default and the else block will run.
        if let anotherPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [anotherPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error decoding the data. \(error)")
        }
        
        tableView.reloadData()
    
}
    
}


    extension ToDoListViewController : UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            // used to sort the search results. square brackets because the output we get would be in array.
            
            loadItems(with: request , predicate: predicate )
            
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            if searchBar.text?.count == 0 {
                
                loadItems()
                
               DispatchQueue.main.async {
                    
                    searchBar.resignFirstResponder()
                    
                }
                
                // searchBar.resignFirstResponder() means that searchBar should no longer be the thing that's currently selected. i.e. make the cursor and keyboard go away.
               //dispatch queue is the manager who assigns this project to different threads. we asked it to get the main queue (main thread) and run the following thing. this will make .resignFirstResponder run in the foreground and not in the background
                
            }
            
        }
        
        
    }









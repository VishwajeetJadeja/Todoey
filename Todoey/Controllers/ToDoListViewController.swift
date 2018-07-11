//
//  ViewController.swift
//  Todoey
//
//  Created by vishwajeet on 29/06/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController {

    var itemArray : Results<Item>?
    //array of objects of item instead of array of strings. objects that we make of the class item go into this array
    
    let realm = try! Realm()
    
    
    
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
        
        return itemArray?.count ?? 1
        
        
        
    }
    
    
    //now this will make a cell for us, one cell at a time
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            //indexpath.row starts from 0 (as row begins from 0). hence our array will start from 0 index.
            // indexpath contains properties such as row and section. i.e. the location of the cell.
            
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            
            cell.textLabel?.text = "Nothing is added yet"
            
        }
        
        
        
        

        return cell
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    //these are in built tableView delegate methods that we got because our superclass is tableViewController instead of simple UIViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            
            do {
                try realm.write {
                 //   realm.delete(item)   to delete the row (item) as soon as we tap on it i.e. select it.
                item.done = !item.done
                }
            } catch{
                    print("Error updating the realm data. \(error)")
                }
            }
        
        tableView.reloadData()
        
        
        
        
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
        
        
//       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//                // this means that if the value of .done is true, the value will become opposite and will be stored in .done on LHS
//                //all this would happen when a particular row is selected as it is in the function didselectRowAt
//
//
//        saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        //after all the processes are done, this will deselect the row (i.e. remove the highlight on the row)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "New ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print("success")
            
            
            //here we will take a new object called newitem as we need to store the value of textfield.text into newItem.title so that we can put newItem into the array
            
            
            if let currentCategory = self.selectedCategory {
            
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                        newItem.date = Date()
                    self.selectedCategory?.items.append(newItem)
                        // this last line shows that as we can't use our parentCategory relationship to store items in the selected parent category, we have to use the relationship object from the class 'Category' that is items and we append an item into that.
                        
                      

                }
                } catch {
                    
                    print("Error saving items in realm \(error)")
                }
            }
            
                self.tableView.reloadData()
            
                }
        
       
            
            alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
                
                
                textField = alertTextField
            
               }
        
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
        
        
    }
    


    
    
    //here we will give loadItems a default parameter, so if there is no input, it will take the default value into consideration
    func loadItems() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)



        tableView.reloadData()

}
    
}


    extension ToDoListViewController : UISearchBarDelegate {

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            
            tableView.reloadData()
            
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









//
//  ViewController.swift
//  ToDoList
//
//  Created by Bibash Kc on 4/2/18.
//  Copyright © 2018 Bibash Kc. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creating a file path to document folder for this app
     //loadItems()
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
//            itemArray = items
//        }
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueFalse
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//           cell.accessoryType = .none
//        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueFalse
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status,\(error)")
            }

        }
        tableView.reloadData()
     
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
//        if itemArray[indexPath.row].done == true {
//            itemArray[indexPath.row].done = false
//        } else {
//            itemArray[indexPath.row].done = true
//        }
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//         saveItems()
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add New ToDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click the Add Item button
           
        if let currentCategory = self.selectedCategory {
            do {
             try self.realm.write {
                let newItem = Item()
                newItem.title = textFeild.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
            } catch {
                print("Error Saving new items, \(error)")
            }
            
            }
            self.tableView.reloadData()
    
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new Item"
            textFeild = alertTextFeild
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}
 //Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        
    }

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//       // request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


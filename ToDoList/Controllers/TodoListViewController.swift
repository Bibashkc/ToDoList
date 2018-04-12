//
//  ViewController.swift
//  ToDoList
//
//  Created by Bibash Kc on 4/2/18.
//  Copyright © 2018 Bibash Kc. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Creating a file path to document folder for this app
     loadItems()
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
//            itemArray = items
//        }
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueFalse
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//           cell.accessoryType = .none
//        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueFalse
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         saveItems()
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add New ToDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click the Add Item button
            
        let newItem = Item(context: self.context) // Item is the class or entity inside datamodel
        newItem.title = textFeild.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.itemArray.append(newItem)
         self.saveItems()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new Item"
            textFeild = alertTextFeild
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        
        do {
           try context.save()
           
        } catch {
           print("Error Saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name  MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }
        else  {
            request.predicate = categoryPredicate
        }
        //if let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate]) {
        //request.predicate = compoundPredicate
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
// Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       // request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


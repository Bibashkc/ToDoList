//
//  ViewController.swift
//  ToDoList
//
//  Created by Bibash Kc on 4/2/18.
//  Copyright © 2018 Bibash Kc. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Kill him"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Throw him"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
            itemArray = items
        }
       
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
         tableView.reloadData()
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add New ToDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click the Add Item button
        let newItem = Item()
        newItem.title = textFeild.text!
          self.itemArray.append(newItem)
          self.defaults.set(self.itemArray, forKey: "TodoListArray")
          self.tableView.reloadData()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new Item"
            textFeild = alertTextFeild
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


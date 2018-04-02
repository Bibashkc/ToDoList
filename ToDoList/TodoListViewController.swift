//
//  ViewController.swift
//  ToDoList
//
//  Created by Bibash Kc on 4/2/18.
//  Copyright © 2018 Bibash Kc. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Myself", "Buy Eggs", "Go to gym"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
             tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add New ToDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click the Add Item button
          self.itemArray.append(textFeild.text!)
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


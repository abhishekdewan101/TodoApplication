//
//  ViewController.swift
//  TodoApplication
//
//  Created by Abhishek Dewan on 3/22/18.
//  Copyright © 2018 Abhishek Dewan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
       
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewTodoButtonPressed(_ sender: Any) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text! != "") {
                self.itemArray.append(Item(title: textField.text!, done: false))
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            } else {
                let emptyAlert = UIAlertController(title: "", message: "Todo cannot be empty.Please try again", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
                    emptyAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(emptyAlert,animated: true,completion: nil)
            }
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add a new Todo Item"
        }
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
}


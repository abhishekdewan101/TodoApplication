//
//  ViewController.swift
//  TodoApplication
//
//  Created by Abhishek Dewan on 3/22/18.
//  Copyright © 2018 Abhishek Dewan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        loadItems()
    }
    
    func loadItems(withPerformRequest:NSFetchRequest<Item> = Item.fetchRequest()){
        do {
           itemArray = try context.fetch(withPerformRequest)
        } catch {
            print(error)
        }
        tableView.reloadData()
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
    
    fileprivate func saveDataToProperList() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        tableView.reloadData()
        
        saveDataToProperList()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewTodoButtonPressed(_ sender: Any) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text! != "") {
                let newItem = Item(context: self.context )
                newItem.done = false;
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.saveDataToProperList()
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

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(withPerformRequest: fetchRequest)
    }
}


//
//  CategoryViewController.swift
//  TodoApplication
//
//  Created by Abhishek Dewan on 3/24/18.
//  Copyright © 2018 Abhishek Dewan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func loadItems(withPerformRequest:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(withPerformRequest)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    fileprivate func saveDataToProperList() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationSegue = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationSegue.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addNewCategoryButtonPressed(_ sender: Any) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text! != "") {
                let newCategory = Category(context:self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveDataToProperList()
                self.tableView.reloadData()
            } else {
                let emptyAlert = UIAlertController(title: "", message: "Todo entry cannot be empty.Please try again", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
                    emptyAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(emptyAlert,animated: true,completion: nil)
            }
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add a new Todo Category"
        }
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
}

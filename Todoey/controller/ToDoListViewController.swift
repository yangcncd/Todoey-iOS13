//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
     
    var itemArray: [Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("myItem2.plist")
    
    //to create our own plist comment follow line out
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        // todolist plist is in:
        //Users/yangding/Library/Developer/CoreSimulator/Devices/786AC59E-339E-4D84-B797-3A43B29FFB0E/data/Containers/Data/Application/A0D464D8-7F10-47EF-AC29-0CDFDF57AEE7/Library/Preferences 
        
        self.loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = self.itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        //self.saveItems()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        //tableView.reloadData()
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var newThingToDoTextField :UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in 
            let newitem = Item()
            newitem.title = newThingToDoTextField.text!
            self.itemArray.append(newitem)
            
            // comment self.defaults.set out and use encoder saveItems() to save data
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "write new item please"
            newThingToDoTextField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch{
            print("Error by encoding: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    func loadItems(){
        if let data = try? Data(contentsOf: self.dataFilePath!){// try? turns Data(contentsOf: self.dataFilePath!) into Optinal
            let decoder = PropertyListDecoder()
            
            do {
                self.itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error by decode the todolist: \(error)")
            }
        }
    }
    
    
}


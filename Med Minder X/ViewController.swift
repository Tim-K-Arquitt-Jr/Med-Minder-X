//
//  ViewController.swift
//  Med Minder X
//
//  Created by Timothy Arquitt on 4/23/19.
//  Copyright © 2019 Tim Arquitt, Jr. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    


}

class medViewController: UITableViewController {
    
    var items = [Med_Minder_X]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAT indexPath: indexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        items[indexPath.row].completed = !items[indexPath.row].completed
        
        saveMeds()
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: indexPath) -> Bool {
    
        return true
    
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: indexPath){
        
        if (editingStyle == .delete) {
            let.item = items[indexPath.row]
            items.remove(at: indexPath.row)
            context.delete(item)
            
            do{
            try context.save()
            }catch{
                print("Error deleting meds with \(Error)")
            }
            
            tableView.deleteRows(at: [IndexPath], with: .automatic)
            
        }
        
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Meds", message: "", preferredStyle: alert)
        let action = UIAlertAction(title: "Add Meds", style: .default) {(action) in
            let newMeds = Med_Minder_X(context: self.context)
            newMeds.name = textField.text!
            self.items.append(newMeds)
            self.saveMeds()
            
        }
        
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add Medicine and Dosage"
            
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveMeds(){
        
        do{
            try context.save()
        }catch{
            print("Error with saving\(Error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadMeds(){
        let request: NSFetchRequest <items> = items.fetchRequest()
        
        do{
        items = try context.fetch(request)
        }catch{
            
            print("Error fetching from context\(Error)")
        }
        
        tableView.reloadData()
        
        }
        
    
    
}

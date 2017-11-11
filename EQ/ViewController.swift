//
//  ViewController.swift
//  PageControl
//
//  Created by Alexander Sanchez de la Cerda on 11.11.17.
//  Copyright © 2017 Alexander Sanchez de la Cerda. All rights reserved.
//

import UIKit
import CoreData

// doesWork ??
class ViewController: UIViewController {
    
    //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        // let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedObjectContext.delete(item)
            }
            
            // Save Changes
            try managedObjectContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        title = "Equilibrium"
        
        //save(name: "test88")
        //self.tableView.reloadData()
        //self.save(name: "not cool")
        //self.tableView.reloadData()
        //tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        //tableView.delegate      =   self as! UITableViewDelegate
        //tableView.dataSource    =   self
        if (tableView != nil) {
            loadGoals(tasks: ["Sport", "Personal Project", "Education", "Social", "Reading"])
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
            tasks = try managedContext.fetch(fetchRequest)
            //print("YYYYYY",tasks[1].dictionaryWithValues(forKeys: ["name"]))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                in: managedContext)!
        
        let task = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        task.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            tasks.append(task)
            //print(tasks)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadGoals(tasks: [String]) {
        for task in tasks {
            save(name: task)
        }
    }


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = task.value(forKeyPath: "name") as? String
        return cell
    }
}





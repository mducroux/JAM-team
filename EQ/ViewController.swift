//
//  ViewController.swift
//  PageControl
//
//  Created by Alexander Sanchez de la Cerda on 11.11.17.
//  Copyright © 2017 Alexander Sanchez de la Cerda. All rights reserved.
//

import UIKit
import CoreData
import M13Checkbox


class ViewController: UIViewController {
    
    //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [NSManagedObject] = []
    let myGoals = ["            Sport", "            Personal Project", "            Education", "            Social", "            Reading"]
    
    //@IBOutlet weak var checkbox: M13Checkbox!
    var checkboxes = [M13Checkbox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        for pixel in 1...5 {
            checkboxes.append(M13Checkbox(frame: CGRect(x: 20.0, y: -480.0 + 100.0 * Double(pixel), width: 60.0, height: 60.0)))
        }
        //let zipped = Array(zip(myGoals, checkboxes))
        print(checkboxes.count)

    /**
 /////////  begin of delete
 */
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
        
   /**
     /////////  end of delete
   */
        
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
            self.tableView.backgroundColor = UIColor.white
            loadGoals(tasks: myGoals)
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
        task.setValue(false, forKeyPath: "checked")
        
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
    
    func change(name: String, checked: Bool) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
        
        var value: NSManagedObject = NSManagedObject();
        for item in tasks {
            if(item.value(forKeyPath: "name") as! String == name) {
                value = item
            }
        }
        
        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
//        let task = NSManagedObject(entity: entity,insertInto: managedContext)
        
        value.setValue(checked, forKeyPath: "checked")
        
//        do {
//            try managedContext.save()
//            tasks.append(task)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
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
        //print(indexPath.row.description)
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let checkbox = M13Checkbox(frame: CGRect(x: 20.0, y: 0.0, width: 80.0, height: 80.0))
       // M13Checkbox.Animation.bounce(M13Checkbox.AnimationStyle.fill)
        
        /// here we handle our checkboxes
        let checkbox = checkboxes[indexPath.row]

        if (checkbox.checkState == M13Checkbox.CheckState.checked) {
            task.setValue(true, forKey: "checked")
        } else { task.setValue(false, forKey: "checked") }

        checkbox.checkmarkLineWidth = CGFloat(2.8)
        checkbox.boxLineWidth = CGFloat(2.8)
        checkbox.tintColor = UIColor(red:0.19, green:0.39, blue:0.48, alpha:1.0) //.init(red: CGFloat(48), green: CGFloat(100), blue: CGFloat(122), alpha: CGFloat(1))
        if (task.value(forKey: "checked") as! Bool) { checkbox.setCheckState(M13Checkbox.CheckState.checked, animated: true) }
        else { checkbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: true) }
        cell.contentView.addSubview(checkbox)
        
        /// here we handle the cell & its text
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        cell.textLabel?.text = task.value(forKeyPath: "name") as? String
        return cell
    }
}

//class CustomCell: UITableViewCell {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var check: M13Checkbox!
//    
//    //Handles the cell selected state
////    var checked: Bool! {
////        didSet {
////            if (self.checked == true) {
////                self.check.image = UIImage(named: "CheckBox-Selected")
////            }else{
////                self.tickImageView.image = UIImage(named: "CheckBox-Normal")
////            }
////        }
////    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
////        checked = false
//        self.layoutMargins = UIEdgeInsets.zero
//        self.separatorInset = UIEdgeInsets.zero
//}
//}



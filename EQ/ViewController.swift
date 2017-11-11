//
//  ViewController.swift
//  PageControl
//
//  Created by Alexander Sanchez de la Cerda on 11.11.17.
//  Copyright © 2017 Alexander Sanchez de la Cerda. All rights reserved.
//

import UIKit
// doesWork ??
class ViewController: UIViewController {
    
    var names: [String] = ["Sport", "Education", "Personal Project", "Social", "Reading"]
    
    //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text = names[indexPath.row]
            return cell
    }
}


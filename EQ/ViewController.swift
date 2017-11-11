//
//  ViewController.swift
//  PageControl
//
//  Created by Alexander Sanchez de la Cerda on 11.11.17.
//  Copyright © 2017 Alexander Sanchez de la Cerda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tasklist"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    var tasks: [String] = []



    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text = tasks[indexPath.row]
    return cell
  }
}

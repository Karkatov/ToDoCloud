//
//  TableViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit

class SecondViewController: UIViewController {

        private let myArray = ["First","Second","Third"]
        private var tableView = UITableView()

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.frame = view.bounds
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            tableView.dataSource = self
            tableView.delegate = self
            self.view.addSubview(tableView)
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
           tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Num: \(indexPath.row)")
            print("Value: \(myArray[indexPath.row])")
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myArray.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
            cell.textLabel!.text = "\(myArray[indexPath.row])"
            return cell
        }
    }

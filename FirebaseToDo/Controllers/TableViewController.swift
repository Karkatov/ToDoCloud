//
//  TableViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit

class TableViewController: UIViewController {

        private let myArray = ["First","Second","Third"]
        private var tableView = UITableView()

        override func viewDidLoad() {
            super.viewDidLoad()

            let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
            
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
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

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    @objc func addNote() {
        print("DONE")
        let alertController = UIAlertController(title: "Новая заметка", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
            tf.autocapitalizationType = .sentences
            
            tf.clearButtonMode = .always 
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { action in
            alertController.textFields?.first
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
}

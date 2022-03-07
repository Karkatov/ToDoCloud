//
//  TableViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TableViewController: UIViewController {

    var user: UserModel!
    var ref: DatabaseReference!
    var tasks: [Task] = []
    
        private let myArray = ["First","Second","Third"]
        private var tableView = UITableView()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            tableView.frame = view.bounds
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            tableView.dataSource = self
            tableView.delegate = self
            self.view.addSubview(tableView)
            
            let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
                        navigationItem.rightBarButtonItem = rightBarButtonItem
                        
                       navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(signOut))
            
                        guard let currentUser = Auth.auth().currentUser else { return }
                        user = UserModel(user: currentUser)
                        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
            
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
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            
            guard let tf = alertController.textFields?.first, tf.text != "" else { return }
        
            let task = Task(title: tf.text!, userID: (self?.user.uid)!)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .default)
        
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func signOut() {
        do { try Auth.auth().signOut()
            
        }
        catch { print("already logged out") }
        
        self.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}

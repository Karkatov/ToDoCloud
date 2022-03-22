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
    var tasks = Array<Task>()
    var path = "task"
    var editButton = UIBarButtonItem()
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        tableView.animateTableView()
        setButtons()
        
        createUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
extension TableViewController {
    
    func createUser() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        
        let taskVC = TasksViewController()
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks").child(path)
        
    }
    
    @objc func addNote() {
        let alertController = UIAlertController(title: "Новая заметка", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
            tf.autocapitalizationType = .sentences
            tf.clearButtonMode = .always
            tf.delegate = self
            
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            
            guard let tf = alertController.textFields?.first, tf.text != "" else { return }
            let task = Task(title: tf.text!, notes: tf.text!, userID: (self?.user.uid)!)
            let taskRef = self?.ref.child("\(task.notes)".lowercased())
            taskRef?.setValue(["notes" : task.notes,
                               "userID" : task.userID,
                               "completed" : task.completed])
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .default)
        
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func setButtons() {
        
        let addNewNote
        = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        addNewNote.tintColor = .white
        
        let showWeather = UIBarButtonItem(image: UIImage(systemName: "tray.full"), style: .plain, target: self, action: #selector(showTray))
        showWeather.tintColor = .white
        
        navigationItem.rightBarButtonItems = [addNewNote, showWeather]
        //editButton = editButtonItem
        //navigationItem.leftBarButtonItem = editButton
    }
    
    func setTableView() {
        
        let backgroundColor = UIColor(red: 25/255,
                                      green: 75/255,
                                      blue: 109/255,
                                      alpha: 1)
        tableView.backgroundColor = backgroundColor
        
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    @objc func showTray() {
        
    }
    
}
extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let task = tasks[indexPath.row]
        let isCompleted = task.completed
        cell.textLabel!.text = task.notes
        toogleCompletion(cell, isCompleted: isCompleted)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        let task = tasks[indexPath.row]
        task.ref?.removeValue()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toogleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed" : isCompleted])
        
    }
    
    func toogleCompletion( _ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }

    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let button = UIContextualAction(style: .normal, title: nil) { <#UIContextualAction#>, <#UIView#>, <#@escaping (Bool) -> Void#> in
//            <#code#>
//        }
//        
//        return UISwipeActionsConfiguration(actions: <#T##[UIContextualAction]#>)
//        
//    }
    //    override func setEditing(_ editing: Bool, animated: Bool) {
    //        super.setEditing(editing, animated: animated)
    //
//        if editing {
//            self.editButton.title = "Готово"
//            tableView.setEditing(editing, animated: true)
//        } else {
//            tableView.endEditing(true)
//            self.editButton.title = "Изменить"
//        }
//    }

}

extension TableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location != 45 else {
            print(range.location)
            return false }
        return true
    }
}

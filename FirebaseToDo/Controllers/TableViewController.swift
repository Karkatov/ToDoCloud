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
    
    var editButton = UIBarButtonItem()
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        tableView.animateTableView()
        setButtons()
        
        createUser()
        
        tabBarController?.tabBar.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            self.tabBarController?.tabBar.frame.origin = CGPoint(x: 20, y: self.view.frame.size.height + 150)
            
            self.tabBarController?.tabBar.frame.origin = CGPoint(x: 20, y: self.view.frame.size.height - 200)
        }
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarController?.setMyTabBar(tabBarController: tabBarController!)
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
        cell.textLabel!.text = task.title
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
    
    
    
    func createUser() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    @objc func addNote() {
        let alertController = UIAlertController(title: "Новая заметка", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
            tf.autocapitalizationType = .sentences
            
            tf.clearButtonMode = .always
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            
            guard let tf = alertController.textFields?.first, tf.text != "" else { return }
            
            let task = Task(title: tf.text!, userID: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(["title" : task.title,
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
        
        let signOut = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(signOut))
        signOut.tintColor = .white
        //navigationItem.leftBarButtonItem = signOut
        editButton = editButtonItem
        navigationItem.leftBarButtonItem = editButton
    }
    
    func setTableView() {
        
        let backgroundColor = UIColor(red: 25/255,
                                      green: 75/255,
                                      blue: 109/255,
                                      alpha: 1)
        tableView.backgroundColor = backgroundColor
        navigationController?.tabBarController?.tabBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    @objc func showTray() {
        
    }
    
    @objc func signOut() {
        
        do { try Auth.auth().signOut()
        }
        catch { print("already logged out") }
        
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        let vc = LoginViewController()
        vc.check = false
        print(vc.check)
        vc.ud.set(vc.check, forKey: "check")
    }
}


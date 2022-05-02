//
//  CollectionViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 16.03.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TasksListsViewController: UIViewController {
    
    var user: UserModel!
    var ref: DatabaseReference!
    var tasksList = Array<Task>()
    var collectionView: UICollectionView!
    let secondView = UIView()
    let titleNote = UILabel()
    let sizeHeightScreen = UIScreen.main.bounds.size.height
    var deleteTaskList = UIBarButtonItem()
    var currentIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUser()
        setNavigationController()
        setCollectionView()
        displayMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasksList = _tasks
            self?.collectionView.reloadData()
        }
        view.backgroundColor = .systemGray5
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarController?.setMyTabBar(tabBarController: tabBarController!)
    }
}

extension TasksListsViewController {
    
    func createUser() {
        guard let currentUser = Auth.auth().currentUser else {
            return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("TasksLists")
    }
    
    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TasksCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .systemGray5
        view.addSubview(collectionView)
    }
    
    func setNavigationController() {
        
        titleNote.text = "Заметки"
        titleNote.font = setMyFont(40)
        view.addSubview(titleNote)
        
        let addNewNote
        = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        addNewNote.tintColor = UIColor(red: 5/255, green: 168/255, blue: 46/255, alpha: 1)
        
        deleteTaskList = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(tappedDeleteTaskList))
                deleteTaskList.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItems = [addNewNote, deleteTaskList]
        
        let signOut = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(signOut))
        signOut.tintColor = .red
        
        
        navigationItem.leftBarButtonItems = [signOut]
    }
    
    
    
    @objc func addFolder() {
        let alertController = UIAlertController(title: "Новая папка", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
            tf.delegate = self
            tf.autocapitalizationType = .sentences
            tf.clearButtonMode = .always
            
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
    
    @objc func tappedDeleteTaskList() {
        if deleteTaskList.title == "Изменить" {
            deleteTaskList.title = "Отмена"
            collectionView.isEditing = true
        } else {
            deleteTaskList.title = "Изменить"
            collectionView.isEditing = false
        }
        collectionView.reloadData()
    }
    
    @objc func signOut() {
        do { try Auth.auth().signOut()
        }
        catch { print("already logged out") }
        
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
        self.dismiss(animated: true)
        vc.check = false
        vc.ud.set(vc.check, forKey: "check")
    }
    
    @objc func deleteCurrentTasksList() {
        let taskList = tasksList[currentIndexPath.row]
        taskList.ref?.removeValue()
        let tasks = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks").child(taskList.notes)
        tasks.ref.removeValue()

        collectionView.reloadData()
    }
    
    func setMyFont(_ size: Double) -> UIFont {
        let font = UIFont(name: "Gill Sans", size: size)
        return font!
    }
    
    func showTabBar(_ originX: Double, originY: Double) {
        UIView.animate(withDuration: 1, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            
            self.tabBarController?.tabBar.frame.origin = CGPoint(x: originX, y: self.view.frame.size.height - originY)
        }
    }
    
    func displayMode() {
        if sizeHeightScreen > 850 {
            collectionView.frame = CGRect(x: 0, y: 230, width: view.frame.size.width, height: view.frame.size.height / 1.8)
            titleNote.frame = CGRect(x: 63, y: 180, width: 200, height: 50)
            showTabBar(20, originY: 200)
            titleNote.font = setMyFont(36)
            
        } else if sizeHeightScreen > 800 {
            collectionView.frame = CGRect(x: 0, y: 230, width: view.frame.size.width, height: view.frame.size.height / 1.9)
            titleNote.frame = CGRect(x: 63, y: 180, width: 200, height: 50)
            showTabBar(0, originY: 200)
            titleNote.font = setMyFont(32)
          
        } else {
            collectionView.frame = CGRect(x: 0, y: 180, width: view.frame.size.width, height: view.frame.size.height / 1.6)
            titleNote.frame = CGRect(x: 63, y: 140, width: 200, height: 50)
            showTabBar(0, originY: 200)
            titleNote.font = setMyFont(30)
            
        }
    }
}

extension TasksListsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location != 12 else {
            print(range.location)
            return false }
        return true
    }
}

extension TasksListsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TasksCollectionViewCell.identifier, for: indexPath) as? TasksCollectionViewCell)!
        cell.colorView.layer.cornerRadius = 20
        cell.taskTitleLabel.text = tasksList[indexPath.row].notes
        cell.deleteButton.addTarget(self, action: #selector(deleteCurrentTasksList), for: .touchUpInside)
        currentIndexPath = indexPath
        if deleteTaskList.title == "Отмена" {
            cell.deleteButton.isHidden = false
            cell.colorView.backgroundColor = .systemOrange
        } else {
            cell.deleteButton.isHidden = true
            cell.colorView.backgroundColor = cell.colors.randomElement()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sizeHeightScreen > 850 {
            return CGSize(width: 165, height: 110)
        } else if sizeHeightScreen > 800 {
            return CGSize(width: 140, height: 90)
        } else {
            return CGSize(width: 130, height: 85) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = tasksList[indexPath.row].notes
        let taskTableViewController = TaskTableViewController()
        taskTableViewController.path = task
    
        self.navigationController?.pushViewController(taskTableViewController, animated: true)
        
        dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 50, bottom: 20, right: 10)
    }
}
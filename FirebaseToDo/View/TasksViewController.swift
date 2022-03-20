//
//  CollectionViewController.swift
//  FirebaseToDo
//
//  Created by Duxxless on 16.03.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TasksViewController: UIViewController {
    
    var user: UserModel!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    var collectionView: UICollectionView!
    let secondView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUser()
        setButtons()
        secondView.backgroundColor = .systemGray
        secondView.frame = UIScreen.main.bounds
        view.addSubview(secondView)
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TasksCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.frame = CGRect(x: 0, y: 300, width: view.frame.size.width, height: view.frame.size.height - 450)
        collectionView.backgroundColor = .systemGray
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 1, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            self.tabBarController?.tabBar.frame.origin = CGPoint(x: 20, y: self.view.frame.size.height + 150)
            
            self.tabBarController?.tabBar.frame.origin = CGPoint(x: 20, y: self.view.frame.size.height - 190)
        }
        
    }
    
    
    deinit {
        print("--------------------------------------------------------")
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
            self?.collectionView.reloadData()
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarController?.setMyTabBar(tabBarController: tabBarController!)
        
    }
}


extension TasksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TasksCollectionViewCell.identifier, for: indexPath) as? TasksCollectionViewCell)!
        cell.colorView.layer.cornerRadius = 20
        cell.taskTitleLabel.text = tasks[indexPath.row].notes
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = tasks[indexPath.row].notes
        let tableVC = TableViewController()
        tableVC.path = task
        self.navigationController?.pushViewController(tableVC, animated: true)

        dismiss(animated: true)
    }
}

extension TasksViewController {
    
    func createUser() {
        guard let currentUser = Auth.auth().currentUser else {
            return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks").child("task")
    }
    
    @objc func addNote() {
        let alertController = UIAlertController(title: "Новая заметка", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
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
    
    func setButtons() {
        
        let addNewNote
        = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        addNewNote.tintColor = .white
        
        let showWeather = UIBarButtonItem(image: UIImage(systemName: "tray.full"), style: .plain, target: self, action: #selector(showTray))
        showWeather.tintColor = .white
        
        navigationItem.rightBarButtonItems = [addNewNote, showWeather]
        
        let signOut = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(signOut))
        signOut.tintColor = .white
        navigationItem.leftBarButtonItem = signOut
        //editButton = editButtonItem
        //navigationItem.leftBarButtonItem = editButton
    }
    
    @objc func showTray() {
        print("")
    }
    
    @objc func signOut() {
        do { try Auth.auth().signOut()
        }
        catch { print("already logged out") }
        
        self.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
        let vc = LoginViewController()
        vc.check = false
        print(vc.check)
        vc.ud.set(vc.check, forKey: "check")
    }
}

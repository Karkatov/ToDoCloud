////
////  TasksCollectionView.swift
////  FirebaseToDo
////
////  Created by Duxxless on 16.03.2022.
////
//
//import UIKit
//
//class TasksCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    let cells = ["1","2","3"]
//    
//    init() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        super.init(frame: .zero, collectionViewLayout: layout)
//        
//        backgroundColor = .systemGreen
//        delegate = self
//        dataSource = self
//        
//        register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: TasksCollectionViewCell.identifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = (dequeueReusableCell(withReuseIdentifier: TasksCollectionViewCell.identifier, for: indexPath))
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
//    }
//    
//}
//


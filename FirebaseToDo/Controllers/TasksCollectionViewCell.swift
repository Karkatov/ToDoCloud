//
//  TasksCollectionViewCell.swift
//  FirebaseToDo
//
//  Created by Duxxless on 17.03.2022.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TasksCollectionViewCell"
    
    let colorView: UIView = {
        let view = UIView()
        let colors = UIColor.white
        view.backgroundColor = colors
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "task"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //let title: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(colorView)
        addSubview(taskTitleLabel)
        
        NSLayoutConstraint.activate([
        
        colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
        colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
        colorView.topAnchor.constraint(equalTo: topAnchor),
        colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        taskTitleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 15),
        taskTitleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant:  -15),
        taskTitleLabel.widthAnchor.constraint(equalToConstant: 120)
       ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

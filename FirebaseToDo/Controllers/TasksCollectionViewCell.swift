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
        let colors: [UIColor] = [UIColor.systemTeal,
                                 UIColor.systemGray,
                                 UIColor.systemRed,
                                 UIColor.systemBlue]
        view.backgroundColor = colors.randomElement()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

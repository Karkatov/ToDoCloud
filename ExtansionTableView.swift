//
//  ExtansionTableView.swift
//  FirebaseToDo
//
//  Created by Duxxless on 24.03.2022.
//

import UIKit

extension UITableView {
    func addCorner(){
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}

//
//  APIManager.swift
//  FirebaseToDo
//
//  Created by Duxxless on 02.03.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

struct TaskModel {
    
    let title: String
    let userID: String
    let ref: DatabaseReference?
    var complited: Bool = false
    
    init(title: String, userID: String) {
        
        self.title = title
        self.userID = userID
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        title = snapshotValue["title"] as! String
        userID = snapshotValue["userID"] as! String
        complited = snapshotValue["complited"] as! Bool
        ref = snapshot.ref
    }
}

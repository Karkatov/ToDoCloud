//
//  Tasks.swift
//  FirebaseToDo
//
//  Created by Duxxless on 20.03.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

struct TasksList {
    
    let title: String
    let ref: DatabaseReference?
    
    // создаем данные
    init(title: String) {
        
        self.title = title
        self.ref = nil
    }
    // получаем данные
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        title = snapshotValue["title"] as! String
        ref = snapshot.ref
    }
}

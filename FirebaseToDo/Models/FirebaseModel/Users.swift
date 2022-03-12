//
//  Users.swift
//  FirebaseToDo
//
//  Created by Duxxless on 03.03.2022.
//

import Foundation
import Firebase
import FirebaseAuth

struct UserModel {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}

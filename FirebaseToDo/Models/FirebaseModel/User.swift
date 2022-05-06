//
//  Users.swift
//  FirebaseToDo
//
//  Created by Duxxless on 03.03.2022.
//

import Foundation
import Firebase
import FirebaseAuth

struct UserModel: Codable {
    
    var uid = ""
    var email = ""
    var check = false
    var password = ""
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
    init(password: String, email: String, check: Bool) {
        self.password = password
        self.email = email
        self.check = check
    }
    
    init() {
    }
}

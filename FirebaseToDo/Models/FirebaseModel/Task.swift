

import Foundation
import Firebase
import FirebaseDatabase

struct Task {
    
    let notes: String
    let userID: String
    let ref: DatabaseReference?
    var completed: Bool = false
    
    init(title: String, notes: String, userID: String) {
        
        self.userID = userID
        self.notes = notes
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        userID = snapshotValue["userID"] as! String
        completed = snapshotValue["completed"] as! Bool
        notes = snapshotValue["notes"] as! String
        ref = snapshot.ref
    }
}

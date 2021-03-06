

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    var user = UserModel()
    let userDefaults = UserDefaults.standard
    
    func saveUser(_ user: UserModel) {
        let encoder = JSONEncoder()
        guard let userEncoded = try? encoder.encode(user) else { return }
        userDefaults.set(userEncoded, forKey: "savedUser")
    }
    func getUser() -> UserModel {
        let decoder = JSONDecoder()
        guard let data = userDefaults.object(forKey: "savedUser") as? Data else { return user }
        guard let savedUser = try? decoder.decode(UserModel.self, from: data) else { return user }
        user = savedUser
        return savedUser
    }
}

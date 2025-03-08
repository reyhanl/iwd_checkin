//
//  UserManager.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class UserManager{
    static var shared = UserManager()
    var userKey = "user"
    func updateBalance(balance: Double) throws{
        guard let data = UserDefaults.standard.value(forKey: userKey) as? Data else{
            throw CustomError.userNotFound
        }
        var user: User = try JSONDecoder().decode(User.self, from: data)
        user.balance = balance
        let encoder = JSONEncoder()
        let newData = try encoder.encode(user)
        UserDefaults.standard.setValue(newData, forKey: userKey)
    }
    
    func fetchUser() throws -> User{
        guard let data = UserDefaults.standard.value(forKey: userKey) as? Data else{
            throw CustomError.userNotFound
        }
        let user: User = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    func makeNewUser(){
        let user = User(balance: 500000)
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(user)
            UserDefaults.standard.setValue(data, forKey: userKey)
        }catch{
            print("Error: \(error.localizedDescription)")
        }
    }
}

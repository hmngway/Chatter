//
// AuthService.swift
// Chatter
//
// Created on 10/14/17.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowercaseEmail = email.lowercased()
        
        // Define the body
        let body: [String: Any] = [
            "email": lowercaseEmail,
            "password": password
        ]
        
        // Create the Alamofire network request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowercaseEmail = email.lowercased()
        
        // Define the body
        let body: [String: Any] = [
            "email": lowercaseEmail,
            "password": password
        ]
        
        // Create the Alamofire network request
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                // Get the data from the response
                guard let data = response.data else { return }
                
                // Use the data
                let json = JSON(data: data)
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                
                self.isLoggedIn = true
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowercaseEmail = email.lowercased()
        
        // Define the body
        let body: [String: Any] = [
            "name": name,
            "email": lowercaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        // Create the Alamofire network request
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                // Get the data from the response
                guard let data = response.data else { return }
                
                // Set the data
                self.setUserInfo(data: data)
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        // Create the Alamofire GET request
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                // Get the data from the response
                guard let data = response.data else { return }
                
                // Set the data
                self.setUserInfo(data: data)
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUserInfo(data: Data) {
        
        let json = JSON(data: data)
        UserDataService.instance.id = json["_id"].stringValue
        UserDataService.instance.avatarColor = json["avatarColor"].stringValue
        UserDataService.instance.avatarName = json["avatarName"].stringValue
        UserDataService.instance.email = json["email"].stringValue
        UserDataService.instance.name = json["name"].stringValue
    }
    
}

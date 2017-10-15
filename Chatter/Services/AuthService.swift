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
                let userEmail = json["user"].stringValue
                let authToken = json["token"].stringValue
                
                // Set the user e-mail and auth token
                self.authToken = authToken
                self.userEmail = userEmail
                
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
        
        // Define the header
        let header = [
            "Authorization": "Bearer \(authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        // Define the body
        let body: [String: Any] = [
            "name": name,
            "email": lowercaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        // Create the Alamofire network request
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if response.result.error == nil {
                // Get the data from the response
                guard let data = response.data else { return }
                
                // Use the data
                let json = JSON(data: data)
                let userId = json["_id"].stringValue
                let avatarColor = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                let email = json["email"].stringValue
                let userName = json["name"].stringValue
                
                // Set the values in the user data service
                UserDataService.instance.name = userName
                UserDataService.instance.email = email
                UserDataService.instance.id = userId
                UserDataService.instance.avatarColor = avatarColor
                UserDataService.instance.avatarName = avatarName
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}

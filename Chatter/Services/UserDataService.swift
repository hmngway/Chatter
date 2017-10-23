//
// UserDataService.swift
// Chatter
//
// Created on 10/14/17.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    fileprivate var _id = ""
    fileprivate var _avatarColor = ""
    fileprivate var _avatarName = ""
    fileprivate var _email = ""
    fileprivate var _name = ""
    fileprivate var _isMinimizing = false
    
    var id: String {
        get {
            return _id
        } set {
            _id = newValue
        }
    }
    
    var avatarColor: String {
        get {
            return _avatarColor
        } set {
            _avatarColor = newValue
        }
    }
    
    var avatarName: String {
        get {
            return _avatarName
        } set {
            _avatarName = newValue
        }
    }
    
    var email: String {
        get {
            return _email
        } set {
            _email = newValue
        }
    }
    
    var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
    
    var isMinimizing: Bool {
        get {
            return _isMinimizing
        } set {
            _isMinimizing = newValue
        }
    }
    
    func returnCGColor(components: String) -> CGColor {
        
        let scanner = Scanner(string: components)
        
        // Define which characters to skip
        let skipped = CharacterSet(charactersIn: "[], ")
        
        // Set the delimiter
        let comma = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a: NSString?
        
        // Set the rgba variables
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        // Set a default color in case one of the rgba variables fails when unwrapped
        let defaultColor = CGColor(red: 0.69, green: 0.85, blue: 0.99, alpha: 1.0)
        
        // Unwrap the rgba variables
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        // Convert the rgba values into floats
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        // Create the CGColor
        let newCGColor = CGColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newCGColor
    }
    
    func logoutUser() {
        
        _id = ""
        _avatarName = ""
        _avatarColor = ""
        _email = ""
        _name = ""
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        AuthService.instance.isLoggedIn = false
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    
}

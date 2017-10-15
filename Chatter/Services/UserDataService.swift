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
    
    func logoutUser() {
        _id = ""
        _avatarName = ""
        _avatarColor = ""
        _email = ""
        _name = ""
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        AuthService.instance.isLoggedIn = false
    }
    
}

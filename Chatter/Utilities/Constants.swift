//
// Constants.swift
// Chatter
//
// Created on 10/12/17.
//

import Cocoa

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "https://mac-chatter.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)/channel"

// Colors
let chatPurple = NSColor(calibratedRed: 0.30, green: 0.22, blue: 0.29, alpha: 1.00)
let chatGreen = NSColor(calibratedRed: 0.22, green: 0.66, blue: 0.68, alpha: 1.00)

// Fonts
let AVENIR_REGULAR = "AvenirNext-Regular"
let AVENIR_BOLD = "AvenirNext-Bold"

// Notifications
let USER_INFO_MODAL = "modalUserInfo"
let NOTIF_PRESENT_MODAL = Notification.Name("presentModal")
let NOTIF_CLOSE_MODAL = Notification.Name("closeModal")
let USER_INFO_REMOVE_IMMEDIATELY = "modalRemoveImmediately"
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

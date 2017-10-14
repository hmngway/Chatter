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

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

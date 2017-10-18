//
//  AppDelegate.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        SocketService.instance.establishConnection()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        SocketService.instance.closeConnection()
    }


}


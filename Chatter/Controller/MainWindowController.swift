//
//  MainWindowController.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        
        super.windowDidLoad()
    
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        
        // Set the minimum window size
        window?.minSize = NSMakeSize(950, 600)
        
        // Set the delegate
        window?.delegate = self
    }
    
    func windowWillMiniaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = true
    }
    
    func windowDidDeminiaturize(_ notification: Notification) {
        UserDataService.instance.isMinimizing = false
    }

}

//
//  MainWindowController.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        
        super.windowDidLoad()
    
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
    }

}

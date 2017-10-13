//
//  ToolbarVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class ToolbarVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = chatGreen.cgColor
        
    }
    
}

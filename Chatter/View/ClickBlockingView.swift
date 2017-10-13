//
//  ClickBlockingView.swift
//  Chatter
//
//  Created on 10/13/17.
//

import Cocoa

class ClickBlockingView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    // Override mouse functions to prevent the user from clicking on anything
    override func mouseDown(with event: NSEvent) {}
    
    override func mouseUp(with event: NSEvent) {}
    
    override func mouseDragged(with event: NSEvent) {}
    
    override func mouseMoved(with event: NSEvent) {}
    
}

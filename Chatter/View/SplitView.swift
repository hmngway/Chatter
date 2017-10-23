//
//  SplitView.swift
//  Chatter
//
//  Created on 10/22/17.
//

import Cocoa

class SplitView: NSSplitView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override var dividerThickness: CGFloat {
        get {
            return 0.0
        }
    }
    
}

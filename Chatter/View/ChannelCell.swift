//
//  ChannelCell.swift
//  Chatter
//
//  Created on 10/21/17.
//

import Cocoa

class ChannelCell: NSTableCellView {
    
    // Outlets
    @IBOutlet weak var channelName: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? ""
        channelName.stringValue = "#\(title)"
        channelName.font = NSFont(name: AVENIR_REGULAR, size: 13.0)
    }
    
}

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
    
    func configureCell(channel: Channel, selectedChannel: Int, row: Int) {
        
        let title = channel.channelTitle ?? ""
        channelName.stringValue = "#\(title)"
        channelName.font = NSFont(name: AVENIR_REGULAR, size: 13.0)
        
        // Set the background color for the channels
        wantsLayer = true
        if row == selectedChannel {
            layer?.backgroundColor = chatGreen.cgColor
            channelName.textColor = NSColor.white
        } else {
            layer?.backgroundColor = CGColor.clear
            channelName.textColor = NSColor.controlColor
        }
    }
    
}

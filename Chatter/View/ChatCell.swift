//
//  ChatCell.swift
//  Chatter
//
//  Created on 10/22/17.
//

import Cocoa

class ChatCell: NSTableCellView {
    
    // Outlets
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var userNameLbl: NSTextField!
    @IBOutlet weak var timestampLbl: NSTextField!
    @IBOutlet weak var messageBodyLbl: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        // Set the profile image style
        profileImage.layer?.cornerRadius = 6
    }
    
    func configureCell(chat: Message) {
        
        messageBodyLbl.stringValue = chat.message
        userNameLbl.stringValue = chat.userName
        profileImage.wantsLayer = true
        profileImage.image = NSImage(named: NSImage.Name(rawValue: chat.userAvatar!))
        profileImage.layer?.backgroundColor = UserDataService.instance.returnCGColor(components: chat.userAvatarColor)
        timestampLbl.stringValue = chat.timestamp
    }
    
}

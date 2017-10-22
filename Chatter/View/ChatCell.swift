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
        
        // Format the timestamp
        guard var isoDate = chat.timestamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timestampLbl.stringValue = finalDate
        }
    }
    
}

//
//  ModalProfile.swift
//  Chatter
//
//  Created on 10/15/17.
//

import Cocoa

class ModalProfile: NSView {

    // Outlets
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var userNameText: NSTextField!
    @IBOutlet weak var emailText: NSTextField!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var logoutBtn: NSButton!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalProfile"), owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        setUpView()
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    func setUpView () {
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
        
        // Set the profile image style
        profileImage.layer?.cornerRadius = 10
        profileImage.layer?.borderColor = NSColor.gray.cgColor
        profileImage.layer?.borderWidth = 3
        profileImage.image = NSImage(named: NSImage.Name(rawValue: UserDataService.instance.avatarName))
        // TODO: Add the avatar background color
        
        // Set the logout button style
        logoutBtn.styleButtonText(button: logoutBtn, buttonName: "Logout", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        logoutBtn.layer?.backgroundColor = chatGreen.cgColor
        logoutBtn.layer?.cornerRadius = 7
    }
    
}

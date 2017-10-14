//
//  ModalLogin.swift
//  Chatter
//
//  Created on 10/13/17.
//

import Cocoa

class ModalLogin: NSView {
    
    // Outlets
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var userNameText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    @IBOutlet weak var emailLoginBtn: NSButton!
    @IBOutlet weak var createAccountBtn: NSButton!
    @IBOutlet weak var stackView: NSStackView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalLogin"), owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        setUpView()
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    @IBAction func emailLoginBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func createAccountBtnClicked(_ sender: Any) {
        let closeImmediatelyDict: [String: Bool] = [USER_INFO_REMOVE_IMMEDIATELY: true]
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil, userInfo: closeImmediatelyDict)
        
        let createAccountDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.createAccount]
        NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: createAccountDict)
    }
    
    func setUpView () {
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
        
        // Set the e-mail login button style
        emailLoginBtn.layer?.backgroundColor = chatGreen.cgColor
        emailLoginBtn.layer?.cornerRadius = 7
        emailLoginBtn.styleButtonText(button: emailLoginBtn, buttonName: "Login", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 14.0)
        
        // Set the create account button style
        createAccountBtn.styleButtonText(button: createAccountBtn, buttonName: "Create Account", fontColor: chatGreen, alignment: .center, font: AVENIR_REGULAR, size: 12.0)
    }
    
}

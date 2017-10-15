//
//  ModalCreateAccount.swift
//  Chatter
//
//  Created on 10/14/17.
//

import Cocoa

class ModalCreateAccount: NSView {

    // Outlets
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var nameText: NSTextField!
    @IBOutlet weak var emailText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var createAccountBtn: NSButton!
    @IBOutlet weak var chooseImageBtn: NSButton!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var stackView: NSStackView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalCreateAccount"), owner: self, topLevelObjects: nil)
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
    
    @IBAction func createAccountBtnClicked(_ sender: Any) {
        // Show the progress spinner
        progressSpinner.isHidden = false
        progressSpinner.startAnimation(nil)
        
        // Dim the view
        stackView.alphaValue = 0.4
        
        // Disable the create account button
        createAccountBtn.isEnabled = false
        
        AuthService.instance.registerUser(email: emailText.stringValue, password: passwordText.stringValue) { (success) in
            
            if success {
                AuthService.instance.loginUser(email: self.emailText.stringValue, password: self.passwordText.stringValue, completion: { (success) in
                    
                    // If login is successful, create the user
                    if success {
                        AuthService.instance.createUser(name: self.nameText.stringValue, email: self.emailText.stringValue, avatarName: "dark8", avatarColor: "", completion: { (success) in
                            
                            // Stop and hide the progress spinner
                            self.progressSpinner.stopAnimation(nil)
                            self.progressSpinner.isHidden = true
                            
                            // If user creation is successful, close the create account modal
                            NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func chooseImageBtnClicked(_ sender: Any) {
        
    }
    
    func setUpView () {
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
        
        // Set the profile image style
        profileImage.layer?.cornerRadius = 10
        profileImage.layer?.borderColor = NSColor.gray.cgColor
        profileImage.layer?.borderWidth = 3
        
        // Set the create account button style
        createAccountBtn.layer?.backgroundColor = chatGreen.cgColor
        createAccountBtn.layer?.cornerRadius = 7
        createAccountBtn.styleButtonText(button: createAccountBtn, buttonName: "Create Account", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        
        // Set the choose image button style
        chooseImageBtn.layer?.backgroundColor = chatGreen.cgColor
        chooseImageBtn.layer?.cornerRadius = 7
        chooseImageBtn.styleButtonText(button: chooseImageBtn, buttonName: "Choose Avatar", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
}

//
//  ModalCreateAccount.swift
//  Chatter
//
//  Created on 10/14/17.
//

import Cocoa

class ModalCreateAccount: NSView, NSPopoverDelegate {

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
    @IBOutlet weak var colorWell: NSColorWell!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1.0]"
    let popover = NSPopover()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalCreateAccount"), owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
        
        // Set the popover delegate
        popover.delegate = self
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        setUpView()
    }
    
    func popoverDidClose(_ notification: Notification) {
        if UserDataService.instance.avatarName != "" {
            profileImage.image = NSImage(named: NSImage.Name(rawValue: UserDataService.instance.avatarName))
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    @IBAction func colorPicked(_ sender: Any) {
        profileImage.layer?.backgroundColor = colorWell.color.cgColor
        
        let color = colorWell.color.cgColor
        
        guard let colorArray = color.components?.description else { return }
        
        avatarColor = colorArray
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
                        AuthService.instance.createUser(name: self.nameText.stringValue, email: self.emailText.stringValue, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            // Stop and hide the progress spinner
                            self.progressSpinner.stopAnimation(nil)
                            self.progressSpinner.isHidden = true
                            
                            // If user creation is successful, close the create account modal
                            NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
                            
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func chooseImageBtnClicked(_ sender: Any) {
        popover.contentViewController = AvatarPickerVC(nibName: NSNib.Name(rawValue: "AvatarPickerVC"), bundle: nil)
        popover.show(relativeTo: chooseImageBtn.bounds, of: chooseImageBtn, preferredEdge: .minX)
        popover.behavior = .transient
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

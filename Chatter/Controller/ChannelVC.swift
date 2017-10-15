//
//  ChannelVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class ChannelVC: NSViewController {
    
    //Outlets
    @IBOutlet weak var userNameLbl: NSTextField!
    @IBOutlet weak var addChannelBtn: NSButton!
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setUpView()
        
        // Notification observer for user login/logout
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    func setUpView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = chatPurple.cgColor
        
        // Customize the add channel button
        addChannelBtn.styleButtonText(button: addChannelBtn, buttonName: "Add +", fontColor: .controlColor, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    @IBAction func addChannelBtnClicked(_ sender: Any) {
        
    }
    
    // Called when the user logs in and logs out
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            userNameLbl.stringValue = UserDataService.instance.name
        } else {
            userNameLbl.stringValue = ""
        }
    }
    
}

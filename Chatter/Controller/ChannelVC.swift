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
        
        // Set the delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
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
        if AuthService.instance.isLoggedIn {
            let addChannelDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.addChannel]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: addChannelDict)
        } else {
            let loginDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.logIn]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
    
    func getChannels() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    // Called when the user logs in and logs out
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            getChannels()
            userNameLbl.stringValue = UserDataService.instance.name
        } else {
            userNameLbl.stringValue = ""
        }
    }
    
}

extension ChannelVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let channel = MessageService.instance.channels[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelCell"), owner: nil) as? ChannelCell {
            
            cell.configureCell(channel: channel)
            
            return cell
        }
        
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
}

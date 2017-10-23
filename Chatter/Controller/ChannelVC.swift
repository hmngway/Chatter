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
    
    // Variables
    var selectedChannelIndex = 0
    var selectedChannel: Channel?
    var chatVC: ChatVC?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        
        if UserDataService.instance.isMinimizing == true {
            return
        }
        
        setUpView()
        
        // Notification observer for user login/logout
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    override func viewDidAppear() {
        
        if UserDataService.instance.isMinimizing == true {
            return
        }
        
        chatVC = self.view.window?.contentViewController?.childViewControllers[0].childViewControllers[1] as? ChatVC
        
        // Monitor for channels created by other users
        SocketService.instance.getChannel { (success) in
            
            if success {
                self.tableView.reloadData()
                
                // Select a channel by default so the user doesn't have to select one upon logging in
                if MessageService.instance.channels.count > 0 {
                    self.tableView.selectRowIndexes(IndexSet(integer: self.selectedChannelIndex), byExtendingSelection: false)
                }
            }
        }
        
        // Monitor for unread channels
        SocketService.instance.getChatMessage { (newMessage) in
            
            if newMessage.channelId != self.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
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
                
                // Select a channel by default so the user doesn't have to select one upon logging in
                if MessageService.instance.channels.count > 0 {
                    self.tableView.selectRowIndexes(IndexSet(integer: self.selectedChannelIndex), byExtendingSelection: false)
                }
            }
        }
    }
    
    // Called when the user logs in and logs out
    @objc func userDataDidChange(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            getChannels()
            userNameLbl.stringValue = UserDataService.instance.name
        } else {
            tableView.reloadData()
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
            
            cell.configureCell(channel: channel, selectedChannel: selectedChannelIndex, row: row)
            
            return cell
        }
        
        return NSTableCellView()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        selectedChannelIndex = tableView.selectedRow
        let channel = MessageService.instance.channels[selectedChannelIndex]
        selectedChannel = channel
        
        // Remove the bold styling from unread channels once they're read
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        
        chatVC?.updateWithChannel(channel: channel)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
    
}

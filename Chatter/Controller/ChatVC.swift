//
//  ChatVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class ChatVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var channelTitle: NSTextField!
    @IBOutlet weak var channelDescription: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var typingUsersLbl: NSTextField!
    @IBOutlet weak var messageOutlineView: NSView!
    @IBOutlet weak var messageText: NSTextField!
    @IBOutlet weak var sendMessageBtn: NSButton!
    
    // Variables
    let user = UserDataService.instance
    var channel: Channel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        
        setUpView()
        
        // Notification observer for user login/logout
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    func setUpView() {
        
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        
        // Format the message text outline view
        messageOutlineView.wantsLayer = true
        messageOutlineView.layer?.backgroundColor = CGColor.white
        messageOutlineView.layer?.borderColor = NSColor.controlHighlightColor.cgColor
        messageOutlineView.layer?.borderWidth = 2
        messageOutlineView.layer?.cornerRadius = 5
        
        // Customize the send message button
        sendMessageBtn.styleButtonText(button: sendMessageBtn, buttonName: "Send", fontColor: .darkGray, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
    }
    
    func updateWithChannel(channel: Channel) {
        
        typingUsersLbl.stringValue = ""
        self.channel = channel
        let channelName = channel.channelTitle ?? ""
        let channelDesc = channel.channelDescription ?? ""
        
        channelTitle.stringValue = "#\(channelName)"
        channelDescription.stringValue = channelDesc
        
        getChats()
    }
    
    func getChats() {
        
        guard let channelId = channel?.id else { return }
        
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendMessageBtnClicked(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            // Send the message
            guard let channelId = channel?.id else { return }
            
            SocketService.instance.addMessage(messageBody: messageText.stringValue, userId: user.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageText.stringValue = ""
                }
            })
        } else {
            let loginDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.logIn]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
    
    // Called when the user logs in and logs out
    @objc func userDataDidChange(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            channelTitle.stringValue = "#general"
            channelDescription.stringValue = "This is where we do the chats"
        } else {
            channelTitle.stringValue = "Please log in."
            channelDescription.stringValue = ""
        }
    }
    
}

extension ChatVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner: nil) as? ChatCell {
            
            let chat = MessageService.instance.messages[row]
            cell.configureCell(chat: chat)
            
            return cell
        }
        
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100.0
    }
    
}

//
//  ChatVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

class ChatVC: NSViewController, NSTextFieldDelegate {
    
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
    var isTyping = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the table view delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the message text delegate
        messageText.delegate = self
    }
    
    override func viewWillAppear() {
        
        if UserDataService.instance.isMinimizing == true {
            return
        }
        
        setUpView()
        
        // Notification observer for user login/logout
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Listener for new message information
        SocketService.instance.getChatMessage { (newMessage) in
            
            // Check to make sure the user is logged in & the message is in the current channel
            if newMessage.channelId == self.channel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                // Scroll to the bottom of the channel
                self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
            }
        }
        
        // Listener for users typing
        SocketService.instance.getTypingUsers { (typingUsers) in
            
            guard let channelId = self.channel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                // The user is not the person typing & the users typing are in the current channel
                if typingUser != self.user.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLbl.stringValue = "\(names) \(verb) typing..."
            } else {
                self.typingUsersLbl.stringValue = ""
            }
        }
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
    
    override func controlTextDidChange(_ obj: Notification) {
        
        guard let channelId = channel?.id else { return }
        
        if messageText.stringValue == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", user.name, channelId)
        } else {
            // For the first keystroke
            if isTyping == false {
                SocketService.instance.socket.emit("startType", user.name, channelId)
            }
            
            // For subsequent keystrokes
            isTyping = true
        }
    }
    
    func getChats() {
        
        guard let channelId = channel?.id else { return }
        
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.tableView.reloadData()
            
            // Scroll to the bottom of the channel
            self.tableView.scrollRowToVisible(MessageService.instance.messages.count - 1)
        }
    }
    
    @IBAction func sendMessageBtnClicked(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            // Send the message
            guard let channelId = channel?.id else { return }
            
            SocketService.instance.addMessage(messageBody: messageText.stringValue, userId: user.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageText.stringValue = ""
                    SocketService.instance.socket.emit("stopType", self.user.name, channelId)
                }
            })
        } else {
            let loginDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.logIn]
            NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
        }
    }
    
    @IBAction func messageEnterSent(_ sender: Any) {
        sendMessageBtn.performClick(nil)
    }
    
    
    // Called when the user logs in and logs out
    @objc func userDataDidChange(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            // If a user logs in & no channels exist
            if MessageService.instance.channels.count == 0 {
                channelTitle.stringValue = "Create a channel and get chatting!"
            }
        } else {
            channelTitle.stringValue = "Please log in."
            channelDescription.stringValue = ""
            self.typingUsersLbl.stringValue = ""
            self.tableView.reloadData()
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

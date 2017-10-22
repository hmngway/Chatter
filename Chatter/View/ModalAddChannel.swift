//
//  ModalAddChannel.swift
//  Chatter
//
//  Created on 10/19/17.
//

import Cocoa

class ModalAddChannel: NSView {
    
    // Outlets
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var channelNameText: NSTextField!
    @IBOutlet weak var channelDescriptionText: NSTextField!
    @IBOutlet weak var createChannelBtn: NSButton!
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ModalAddChannel"), owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        setUpView()
    }
    
    @IBAction func createChannelBtnClicked(_ sender: Any) {
        
        SocketService.instance.addChannel(channelName: channelNameText.stringValue, channelDescription: channelDescriptionText.stringValue) { (success) in
            
            if success {
                NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
            }
        }
    }
    
    @IBAction func closeModalClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CLOSE_MODAL, object: nil)
    }
    
    func setUpView () {
        
        self.view.frame = NSRect(x: 0, y: 0, width: 475, height: 300)
        view.layer?.backgroundColor = CGColor.white
        view.layer?.cornerRadius = 7
        
        // Set the create channel button style
        createChannelBtn.styleButtonText(button: createChannelBtn, buttonName: "Create Channel", fontColor: .white, alignment: .center, font: AVENIR_REGULAR, size: 13.0)
        createChannelBtn.layer?.backgroundColor = chatGreen.cgColor
        createChannelBtn.layer?.cornerRadius = 7
    }
    
}

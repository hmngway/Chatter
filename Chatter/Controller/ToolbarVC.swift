//
//  ToolbarVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

enum ModalType {
    case logIn
}

class ToolbarVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var loginImage: NSImageView!
    @IBOutlet weak var loginLbl: NSTextField!
    @IBOutlet weak var loginStack: NSStackView!
    
    // Variables
    var modalBGView: ClickBlockingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setUpView()
    }
    
    func setUpView() {
        
        // Notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(ToolbarVC.presentModal(_:)), name: NOTIF_PRESENT_MODAL, object: nil)
        
        view.wantsLayer = true
        view.layer?.backgroundColor = chatGreen.cgColor
        
        // Gesture recognizer for the login stack
        loginStack.gestureRecognizers.removeAll()
        let profilePage = NSClickGestureRecognizer(target: self, action: #selector(ToolbarVC.openProfilePage(_:)))
        loginStack.addGestureRecognizer(profilePage)
    }
    
    @objc func openProfilePage(_ recognizer: NSClickGestureRecognizer) {
        let loginDict: [String: ModalType] = [USER_INFO_MODAL: ModalType.logIn]
        NotificationCenter.default.post(name: NOTIF_PRESENT_MODAL, object: nil, userInfo: loginDict)
    }
    
    @objc func presentModal(_ notif: Notification) {
        
        if modalBGView == nil {
            modalBGView = ClickBlockingView()
            
            // View constraints will be added explicitly
            modalBGView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(modalBGView, positioned: .above, relativeTo: loginStack)
            
            // Set the view constraints
            let topCn = NSLayoutConstraint(item: modalBGView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50)
            
            let leftCn = NSLayoutConstraint(item: modalBGView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
            
            let rightCn = NSLayoutConstraint(item: modalBGView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
            
            let bottomCn = NSLayoutConstraint(item: modalBGView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            
            // Add the view constraints
            view.addConstraints([topCn, leftCn, rightCn, bottomCn])
            
            // Set the background color
            modalBGView.layer?.backgroundColor = CGColor.black
            modalBGView.alphaValue = 0.0
        }
    }
    
}

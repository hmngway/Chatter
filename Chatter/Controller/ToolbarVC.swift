//
//  ToolbarVC.swift
//  Chatter
//
//  Created on 10/12/17.
//

import Cocoa

enum ModalType {
    case logIn
    case createAccount
}

class ToolbarVC: NSViewController {
    
    // Outlets
    @IBOutlet weak var loginImage: NSImageView!
    @IBOutlet weak var loginLbl: NSTextField!
    @IBOutlet weak var loginStack: NSStackView!
    
    // Variables
    var modalBGView: ClickBlockingView!
    var modalView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        setUpView()
    }
    
    func setUpView() {
        
        // Notification observer for the modal
        NotificationCenter.default.addObserver(self, selector: #selector(ToolbarVC.presentModal(_:)), name: NOTIF_PRESENT_MODAL, object: nil)
        
        // Notification observer for the login modal close button
        NotificationCenter.default.addObserver(self, selector: #selector(ToolbarVC.closeModalNotif(_:)), name: NOTIF_CLOSE_MODAL, object: nil)
        
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
        
        var modalWidth = CGFloat(0.0)
        var modalHeight = CGFloat(0.0)
        
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
            
            // Gesture recognizer for the modal
            let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(ToolbarVC.closeModalClick(_:)))
            modalBGView.addGestureRecognizer(closeBackgroundClick)
        }
        
        // Instantiate the XIB
        guard let modalType = notif.userInfo?[USER_INFO_MODAL] as? ModalType else { return }
        
        switch modalType {
        case ModalType.logIn:
            modalView = ModalLogin()
            modalWidth = 475
            modalHeight = 300
        case ModalType.createAccount:
            modalView = ModalCreateAccount()
            modalWidth = 475
            modalHeight = 300
        }
        
        modalView.wantsLayer = true
        
        // XIB constraints will be added explicitly
        modalView.translatesAutoresizingMaskIntoConstraints = false
        
        modalView.alphaValue = 0.0
        
        view.addSubview(modalView, positioned: .above, relativeTo: modalBGView)
        
        // Set the XIB constraints
        let horizontalConstraint = modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = modalView.widthAnchor.constraint(equalToConstant: modalWidth)
        let heightConstraint = modalView.heightAnchor.constraint(equalToConstant: modalHeight)
        
        // Activate the XIB constraints
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        // Background animation
        NSAnimationContext.runAnimationGroup({ (context) in
            
            // Length of time the animation takes to effect
            context.duration = 0.5
            
            // Animate the background opacity
            modalBGView.animator().alphaValue = 0.6
            
            // Animate the XIB opacity
            modalView.animator().alphaValue = 1.0
            
            self.view.layoutSubtreeIfNeeded()
            
        }, completionHandler: nil)
    }
    
    // Close the login modal with the close button
    @objc func closeModalNotif(_ notif: Notification) {
        
        if let removeImmediately = notif.userInfo?[USER_INFO_REMOVE_IMMEDIATELY] as? Bool {
            closeModal(removeImmediately)
        } else {
            closeModal()
        }
    }
    
    // Close a modal by clicking outside of it
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        closeModal()
    }
    
    func closeModal(_ removeImmediately: Bool = false) {
        
        if removeImmediately {
            self.modalView.removeFromSuperview()
        } else {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.5
                modalBGView.animator().alphaValue = 0.0
                modalView.animator().alphaValue = 0.0
                self.view.layoutSubtreeIfNeeded()
                
            }, completionHandler: {
                if self.modalBGView != nil {
                    self.modalBGView.removeFromSuperview()
                    self.modalBGView = nil
                }
                
                self.modalView.removeFromSuperview()
            })
        }
        
    }
    
}

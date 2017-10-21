//
//  AvatarPickerVC.swift
//  Chatter
//
//  Created on 10/21/17.
//

import Cocoa

enum AnimalType {
    case dark
    case light
}

class AvatarPickerVC: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var segmentControl: NSSegmentedControl!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    // Variables
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate & data source
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AnimalCell"), for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSMakeSize(85.0, 85.0)
    }
    
}

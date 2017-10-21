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
    var animalType = AnimalType.dark

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate & data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        segmentControl.cell?.controlTint = .blueControlTint
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AnimalCell"), for: indexPath)
        
        guard let animalCell = cell as? AnimalCell else { return NSCollectionViewItem() }
        
        animalCell.configureCell(index: indexPath.item, type: animalType)
        
        return animalCell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSMakeSize(85.0, 85.0)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        if let selectedIndexPath = collectionView.selectionIndexPaths.first {
            if animalType == .dark {
                UserDataService.instance.avatarName = "dark\(selectedIndexPath.item)"
            } else {
                UserDataService.instance.avatarName = "light\(selectedIndexPath.item)"
            }
            
            view.window?.cancelOperation(nil)
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        if segmentControl.selectedSegment == 0 {
            animalType = .dark
        } else {
            animalType = .light
        }
        
        collectionView.reloadData()
    }
    
    
}

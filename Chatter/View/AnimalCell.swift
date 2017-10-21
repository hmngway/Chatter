//
//  AnimalCell.swift
//  Chatter
//
//  Created by Harley on 10/21/17.
//

import Cocoa

class AnimalCell: NSCollectionViewItem {
    
    // Outlets
    @IBOutlet weak var animalImage: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        setUpView()
    }
    
    func configureCell(index: Int, type: AnimalType) {
        if type == AnimalType.dark {
            animalImage.image = NSImage(named: NSImage.Name(rawValue: "dark\(index)"))
            view.layer?.backgroundColor = NSColor.lightGray.cgColor
        } else {
            animalImage.image = NSImage(named: NSImage.Name(rawValue: "light\(index)"))
            view.layer?.backgroundColor = NSColor.gray.cgColor
        }
    }
    
    func setUpView() {
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.cornerRadius = 10
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.darkGray.cgColor
    }
    
}

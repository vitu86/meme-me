//
//  MemeMeDetailViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 25/10/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView:UIImageView!
    
    // MARK: Public properties
    var meme:Meme?
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memedImage = meme?.memedImage {
            imageView.image = memedImage
        }
    }
    
}

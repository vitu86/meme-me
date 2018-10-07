//
//  Meme.swift
//  MemeMe
//
//  Created by Vitor Costa on 07/10/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    
    // MARK: Public properties
    var topText:String
    var bottomText:String
    var originalImage:UIImage
    var memedImage:UIImage
    
    init(topText:String, bottomText:String, originalImage:UIImage, memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

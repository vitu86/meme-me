//
//  StrokeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Vitor Costa on 03/10/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

class StrokeTextFieldDelegate: NSObject, UITextFieldDelegate {
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == MemeMeViewController.defaultTextToTopTextView || textField.text == MemeMeViewController.defaultTextToBottomTextView {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

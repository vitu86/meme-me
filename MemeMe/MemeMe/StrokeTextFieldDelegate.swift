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
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP TEXT" || textField.text == "BOTTOM TEXT" {
            textField.text = ""
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textFieldshouldChangeCharactersInreplacementString")
        return true
    }
}

//
//  ViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 30/09/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Private Properties
    private let strokeDelegate:StrokeTextFieldDelegate = StrokeTextFieldDelegate()
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Private functions
    private func configureTextFields () {
        // Set stroke colors
        let memeTextAttributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -3]
        
        // Update values to not lose values from storyboard
        for attributeItem in memeTextAttributes {
            topTextField.defaultTextAttributes.updateValue(attributeItem.value, forKey: attributeItem.key)
            bottomTextField.defaultTextAttributes.updateValue(attributeItem.value, forKey: attributeItem.key)
        }
        
        // Setting delegates
        topTextField.delegate = strokeDelegate
        bottomTextField.delegate = strokeDelegate
    }
    
    // MARK: Notification center functions
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Keyboard Notification Responder Functions
    @objc private func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
}


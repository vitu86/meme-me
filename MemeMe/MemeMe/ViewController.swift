//
//  ViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 30/09/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    
    // MARK: Private Properties
    private let strokeDelegate:StrokeTextFieldDelegate = StrokeTextFieldDelegate()
    
    
    
    // MARK: Actions
    @IBAction func cameraTapped(_ sender: Any) {
        getImageFrom(.camera)
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        getImageFrom(.photoLibrary)
    }
    
    
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    // Configure UI before show to user
    private func configureUI () {
        // TextFields
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
        
        // If there's no camera available, disable the button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // Notification center function
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Notification center function
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Get keyboard height to put view up
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Keyboard Notification Responder Function
    @objc private func keyboardWillShow(_ notification:Notification) {
        // Only handle if the bottom textfield is the one active
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Keyboard Notification Responder Function
    @objc private func keyboardWillHide(_ notification:Notification) {
        // Only handle if the bottom textfield is the one active
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // Open Picker Controller with given type
    private func getImageFrom(_ type:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: Public functions
    // Image Picker Delegate Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}


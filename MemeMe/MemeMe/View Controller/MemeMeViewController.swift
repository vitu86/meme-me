//
//  ViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 30/09/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    // MARK: Private constants
    // Create delegate
    private let strokeDelegate:StrokeTextFieldDelegate = StrokeTextFieldDelegate()
    
    // MARK: Actions
    @IBAction func cameraTapped(_ sender: Any) {
        getImageFrom(.camera)
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        getImageFrom(.photoLibrary)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        shareLogic()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        clearUI()
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
        setStyle(toTextField: bottomTextField)
        setStyle(toTextField: topTextField)
        
        // If there's no camera available, disable the button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Share button only is enabled when meme is ready to share
        shareButton.isEnabled = false
        
        // Toolbar is hidden by default. We need to show it!
        self.navigationController?.isToolbarHidden = false
    }
    
    // Set style of textfields
    func setStyle(toTextField textField: UITextField) {
        // Create text attributes
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0
        ]
        // Set attributes to text field
        textField.defaultTextAttributes = memeTextAttributes
        // Center textfield's text
        textField.textAlignment = .center
        // Capitalize all characters on textfield
        textField.autocapitalizationType = .allCharacters
        // Set delegate
        textField.delegate = strokeDelegate
    }
    
    // Clear all data in UI
    private func clearUI(){
        topTextField.text = ""
        bottomTextField.text = ""
        imageView.image = nil
        shareButton.isEnabled = false
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
    
    // Keyboard notification responder function
    @objc private func keyboardWillShow(_ notification:Notification) {
        // Only handle if the bottom textfield is the one active
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Keyboard notification responder function
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
    
    // Share button logic
    func shareLogic(){
        // Generate memed image
        let memedImage:UIImage = generateMemedImage()
        // Prepare activity view controller to share
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // set function to run when complete
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // If user not cancel, save the memed image
            if completed {
                self.save(memedImage: memedImage)
                self.clearUI()
            }
        }
        
        // iPad needs a barbuttonitem or source view to link to activity controller
        activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        // Show activity
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Generate memed image
    private func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideBars(true)
        hidePlaceholders(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideBars(false)
        hidePlaceholders(false)
        
        return memedImage
    }
    
    // Show/Hide bars
    private func hideBars(_ hide:Bool) {
        self.navigationController?.isToolbarHidden = hide
        self.navigationController?.isNavigationBarHidden = hide
    }
    
    // Revisor suggested me to use placeholder on textfields
    // But this way, if the text is empty, placeholders appear at screenshots.
    // So, I need to hide them like tool bars
    private func hidePlaceholders (_ hide:Bool) {
        if hide {
            topTextField.placeholder = ""
            bottomTextField.placeholder = ""
        } else {
            topTextField.placeholder = "TOP"
            bottomTextField.placeholder = "BOTTOM"
        }
    }
    
    // Save meme in model
    private func save(memedImage:UIImage) {
        let meme:Meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    
    // MARK: Public functions
    // MARK: Image Picker Delegate Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // If user cancel, only dismiss the pick controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // If there's a valid image, put it in imageview
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            // Only enable sharebutton when user choose an image
            shareButton.isEnabled = true
        }
        
        // Dismniss the pick controller
        dismiss(animated: true, completion: nil)
    }
    
}


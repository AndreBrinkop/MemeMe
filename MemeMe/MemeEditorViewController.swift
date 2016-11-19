//
//  ViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 30.10.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    override var prefersStatusBarHidden: Bool { return true }
    static let MIN_FONT_SIZE: CGFloat = 24.0
    static let DEFAULT_FONT_SIZE: CGFloat = 40.0

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    let topTextFieldInitialText = "TOP"
    @IBOutlet weak var bottomTextField: UITextField!
    let bottomTextFieldInitialText = "BOTTOM"
    
    @IBOutlet var topTextFieldLayoutConstraint: NSLayoutConstraint!
    let topTextFieldLayoutConstraintInitialValue: CGFloat = 30.0
    @IBOutlet var bottomTextFieldLayoutConstraint: NSLayoutConstraint!
    let bottomTextFieldLayoutConstraintInitialValue: CGFloat = 30.0
    
    let memeTextAttributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: DEFAULT_FONT_SIZE)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    var activeTextFieldField: UITextField?
    var memedImage: UIImage?
    
    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resetTextFieldPositionAndSize()
    }
    
    private func initializeUI() {
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        imageView.contentMode = .scaleAspectFit
        
        configureTextField(textField: topTextField, initialText: topTextFieldInitialText)
        configureTextField(textField: bottomTextField, initialText: bottomTextFieldInitialText)
        resetTextFieldPositionAndSize()
    }
    
    private func configureTextField(textField: UITextField, initialText: String) {
        textField.delegate = self
        textField.text = initialText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    private func resetTextFieldPositionAndSize() {
        topTextFieldLayoutConstraint.constant = topTextFieldLayoutConstraintInitialValue
        bottomTextFieldLayoutConstraint.constant = bottomTextFieldLayoutConstraintInitialValue
        
        if let font = topTextField.font?.withSize(MemeEditorViewController.DEFAULT_FONT_SIZE) {
            topTextField.font = font
            bottomTextField.font = font
        }
    }
    
    // MARK: Actions
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        var sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if sender.title == "Album" {
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if (cameraAuthorizationStatus == AVAuthorizationStatus.denied){
            alertUserThatCameraAccessIsMissing()
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func alertUserThatCameraAccessIsMissing() {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        var message = "You didn't allow this app to use the camera of your device!"
        if let appName = appName {
            message = "You didn't allow \(appName) to use the camera of your device!"
        }
        let alert = UIAlertController(title: "Capturing failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func share(_ sender: AnyObject) {
        print("Pressed share button")
        memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
            if completed && activityError == nil {
                self.save()
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: Generate Meme
    
    func save() {
        _ = Meme(topText: topTextField.text!, topTextLayoutConstant: topTextFieldLayoutConstraint.constant, topTextFont: topTextField.font!, bottomText: bottomTextField.text!, bottomTextLayoutConstant: bottomTextFieldLayoutConstraint.constant, bottomTextFont: bottomTextField.font!, image: imageView.image!, memedImage: memedImage!)
        // TODO: Storing generated meme object
    }
    
    func generateMemedImage() -> UIImage {
        // Render imageView to an image
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0);

        view.drawHierarchy(in: CGRect(x: 0, y: -imageView.frame.minY, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)

        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
    
    // MARK: GestureRecognizer Actions
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if activeTextFieldField != nil {
            return
        }
        
        if let textField: UITextField = sender.view as? UITextField {
            if sender.numberOfTouches == 1 {
                var yCoordinate: CGFloat = getPannedTextFieldCoordinate(of: sender)
                let (lowerBorder, upperBorder) = getYPositionBorders(of: textField)

                yCoordinate = max(lowerBorder, yCoordinate)
                yCoordinate = min(upperBorder, yCoordinate)
                
                setYPosition(of: textField, y: yCoordinate)
            }
        }
    }
    
    var fontSizeBeforeGesture: CGFloat = 40.0
    var yCenterBeforeGesture: CGFloat = 0.0
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        if activeTextFieldField != nil {
            return
        }
        
        if let textField: UITextField = sender.view as? UITextField {
            
            if sender.state == .began {
                fontSizeBeforeGesture = textField.font!.pointSize
                yCenterBeforeGesture = getYPosition(of: textField) + textField.frame.height / 2.0
            } else if sender.state == .changed {
                
                let (lowerBorder, upperBorder) = getYPositionBorders(of: textField)
                
                if sender.scale <= 1.0 || upperBorder - lowerBorder > 0 {
                    var font = textField.font!
                    font = font.withSize(max(fontSizeBeforeGesture * sender.scale, MemeEditorViewController.MIN_FONT_SIZE))
                    textField.font = font
                    setYPosition(of: textField, centerY: yCenterBeforeGesture)
                }
            }
        }
    }
    
    private func getPannedTextFieldCoordinate(of gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        var yCoordinate: CGFloat = gestureRecognizer.location(in: imageView).y
        let textFieldHeight: CGFloat = gestureRecognizer.view!.frame.height / 2.0
        
        if gestureRecognizer.view == topTextField {
            yCoordinate -= textFieldHeight
        } else {
            yCoordinate -= textFieldHeight
        }
        
        return yCoordinate
    }

    private func getYPositionBorders(of textField: UITextField) -> (CGFloat, CGFloat) {
        if(textField == topTextField) {
            return (0.0, imageView.frame.height - bottomTextFieldLayoutConstraint.constant - (topTextField.frame.height + bottomTextField.frame.height))
        } // textField == bottomTextField
        return (topTextFieldLayoutConstraint.constant + topTextField.frame.height, imageView.frame.height - bottomTextField.frame.height)
    }
    
    private func setYPosition(of textField: UITextField, y: CGFloat) {
        var y = y
        let (lowerBorder, upperBorder) = getYPositionBorders(of: textField)
        
        if y > upperBorder {
            y = upperBorder
        }
        else if y < lowerBorder {
            y = lowerBorder
        }
        
        if textField == topTextField {
            topTextFieldLayoutConstraint.constant = y
        } else {
            bottomTextFieldLayoutConstraint.constant = imageView.frame.height - (y + textField.frame.height)
        }
    }
    
    private func setYPosition(of textField: UITextField, centerY: CGFloat) {
        setYPosition(of: textField, y: centerY - textField.frame.height / 2.0)
    }
    
    private func getYPosition(of textField: UITextField) -> CGFloat {
        if textField == topTextField {
            return topTextFieldLayoutConstraint.constant
        } else {
            return imageView.frame.height - (bottomTextFieldLayoutConstraint.constant + textField.frame.height)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func getInitialText(for textField: UITextField) -> String {
        return (textField == topTextField) ? topTextFieldInitialText : bottomTextFieldInitialText
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextFieldField = textField
        if textField.text == getInitialText(for: textField) {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextFieldField = nil
        if textField.text == "" {
            textField.text = getInitialText(for: textField)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: KeyboardNotifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var viewShiftValue: CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        shiftKeyboardBack()
        
        if let activeTextFieldMaxY = activeTextFieldField?.frame.maxY {
            let keyboardMinY = view.frame.maxY - getKeyboardHeight(notification: notification)
            
            if activeTextFieldMaxY > keyboardMinY {
                viewShiftValue = getKeyboardHeight(notification: notification)
                viewShiftValue = viewShiftValue - (view.frame.maxY - activeTextFieldMaxY)
                view.frame.origin.y -= viewShiftValue
            }
        }
    }
    
    func keyboardWillHide() {
        shiftKeyboardBack()
    }
    
    private func shiftKeyboardBack() {
        if viewShiftValue != 0.0 {
            view.frame.origin.y += viewShiftValue
            viewShiftValue = 0.0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}


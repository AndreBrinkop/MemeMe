//
//  ViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 30.10.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    let initialTopTextFieldText = "TOP"
    @IBOutlet weak var bottomTextField: UITextField!
    let initialBottomTextFieldText = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        topTextField.delegate = self
        topTextField.text = initialTopTextFieldText
        bottomTextField.delegate = self
        bottomTextField.text = initialBottomTextFieldText
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        if sender.title == "Album" {
            print("Pressed album button")
        } else { // Camera
            print("Pressed camera button")
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
            print("Pressed cancel button")
    }
    @IBAction func share(_ sender: AnyObject) {
             print("Pressed share button")
    }
    
    @IBAction func handlePinch(_ sender: UIPanGestureRecognizer) {

        if let textView: UITextField = sender.view as? UITextField {
            var newPositionY: CGFloat = sender.location(in: self.view).y
            let (lowerBorder, upperBorder) = getYPositionBorders(for: textView)
            
            newPositionY = max(lowerBorder, newPositionY)
            newPositionY = min(upperBorder - textView.frame.height, newPositionY)
            textView.frame.origin.y = newPositionY
        }
    }
    
    private func getYPositionBorders(for textField: UITextField) -> (CGFloat, CGFloat) {
        if(textField == topTextField) {
            return (self.imageView.frame.minY, bottomTextField.frame.minY)
        } // textField == bottomTextField
        return (topTextField.frame.maxY, self.imageView.frame.maxY)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func getInitialText(for textField: UITextField) -> String {
        return (textField == topTextField) ? initialTopTextFieldText : initialBottomTextFieldText
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == getInitialText(for: textField) {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = getInitialText(for: textField)
        }
    }
    
}


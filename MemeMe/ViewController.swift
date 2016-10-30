//
//  ViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 30.10.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
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
            let newPosition: CGPoint = sender.location(in: self.view)

            var newPositionY = max(self.imageView.frame.minY, newPosition.y)
            newPositionY = min(self.imageView.frame.maxY - textView.frame.height, newPositionY)
            textView.frame.origin.y = newPositionY
        }
    }
    
}


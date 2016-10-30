//
//  ViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 30.10.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
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
    
}


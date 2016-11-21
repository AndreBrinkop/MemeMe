//
//  ImagePickerHelper.swift
//  MemeMe
//
//  Created by André Brinkop on 21.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ImagePickerHelper {
    static func setupImagePicker(sourceType: UIImagePickerControllerSourceType, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> UIViewController {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

        if sourceType == .camera && cameraAuthorizationStatus == AVAuthorizationStatus.denied {
            return setupInformUserThatCameraAccessIsMissingAlert()
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            imagePicker.sourceType = sourceType
        }

        return imagePicker
    }
    
    static func setupInformUserThatCameraAccessIsMissingAlert() -> UIAlertController {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        var message = "You didn't allow this app to use the camera of your device!"
        if let appName = appName {
            message = "You didn't allow \(appName) to use the camera of your device!"
        }
        let alert = UIAlertController(title: "Capturing failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        return alert
    }
}


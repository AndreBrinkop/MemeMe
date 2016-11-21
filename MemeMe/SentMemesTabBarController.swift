//
//  SentMemesTabBarController.swift
//  MemeMe
//
//  Created by André Brinkop on 21.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesTabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func createMeme(_ sender: Any) {
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        let cameraImagePicker = ImagePickerHelper.setupImagePicker(sourceType: .camera, delegate: self)
        let albumImagePicker = ImagePickerHelper.setupImagePicker(sourceType: .photoLibrary, delegate: self)
        
        if !isCameraAvailable {
            present(albumImagePicker, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { alertAction in
            self.present(cameraImagePicker, animated: true, completion: nil)
        })
        let albumAction = UIAlertAction(title: "Album", style: .default, handler: { alertAction in
            self.present(albumImagePicker, animated: true, completion: nil)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let memeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            memeEditorViewController.image = image
            
            picker.dismiss(animated: true, completion: nil)
            present(memeEditorViewController, animated: true, completion: nil)
        }
    }

}

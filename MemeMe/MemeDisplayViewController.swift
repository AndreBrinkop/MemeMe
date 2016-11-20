//
//  MemeDisplayViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 20.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class MemeDisplayViewController: UIViewController {

    @IBOutlet var memeImageView: UIImageView!
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        memeImageView.image = memedImage
    }

}

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
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme.memedImage
    }

    @IBAction func shareMeme(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

}

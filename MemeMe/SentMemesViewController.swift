//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 19.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController {
    
    // MARK: Properties
    
    var savedMemes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.getMemes()
        }
        set (savedMemes) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setMemes(memes: savedMemes)
        }
    }
    
    // MARK: Actions
    
    func numberOfSavedMemes() -> Int {
        return savedMemes.count
    }
    
    func savedMemeFor(indexPath: IndexPath) -> Meme {
        return savedMemes[indexPath.row]
    }
    
    func displayMemeAt(indexPath: IndexPath) {
        let memeDisplayViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDisplayViewController") as! MemeDisplayViewController
        memeDisplayViewController.meme = savedMemeFor(indexPath: indexPath)
        
        navigationController?.pushViewController(memeDisplayViewController, animated: true)
    }
}

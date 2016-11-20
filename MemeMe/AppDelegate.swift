//
//  AppDelegate.swift
//  MemeMe
//
//  Created by André Brinkop on 30.10.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var memes = [Meme]()
    
    func getMemes() -> [Meme] {
        return memes
    }
    
    func setMemes(memes: [Meme]) {
        self.memes = memes
    }
    
    func addMeme(meme: Meme) {
        memes.append(meme)
    }

}


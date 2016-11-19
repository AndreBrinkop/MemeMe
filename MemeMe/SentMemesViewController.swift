//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 19.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSavedMemes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell")!
        
        let _ = savedMemeFor(indexPath: indexPath)
        // TODO: Configure cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSavedMemes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath)
        
        let _ = savedMemeFor(indexPath: indexPath)
        // TODO: Configure cell
        
        return cell
    }
    
    private func numberOfSavedMemes() -> Int {
        return 0 // placeholder
    }
    
    private func savedMemeFor(indexPath: IndexPath) -> Meme {
        return Meme(topText: "", topTextLayoutConstant: 0.0, topTextFont: UIFont(), bottomText: "", bottomTextLayoutConstant: 0.0, bottomTextFont: UIFont(), image: UIImage(), memedImage: UIImage()) // placeholder
    }
}

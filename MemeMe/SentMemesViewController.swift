//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 19.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var sentMemesTableView: UITableView?
    @IBOutlet var sentMemesCollectionView: UICollectionView?
    
    var savedMemes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let sentMemesTableView = sentMemesTableView {
            sentMemesTableView.reloadData()
        }
        if let sentMemesCollectionView = sentMemesCollectionView {
            sentMemesCollectionView.reloadData()
        }
    }

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
        return savedMemes.count
    }
    
    private func savedMemeFor(indexPath: IndexPath) -> Meme {
        return savedMemes[indexPath.row]
    }
}

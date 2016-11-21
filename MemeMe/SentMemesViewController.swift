//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 19.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet var sentMemesTableView: UITableView?
    @IBOutlet var sentMemesCollectionView: UICollectionView?
    @IBOutlet var sentMemesCollectionFlowLayout: UICollectionViewFlowLayout?
    
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
    
    // MARK: Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sentMemesTableView = sentMemesTableView {
            sentMemesTableView.reloadData()
        }
        if let sentMemesCollectionView = sentMemesCollectionView {
            sentMemesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        if let sentMemesCollectionFlowLayout = sentMemesCollectionFlowLayout {
            sentMemesCollectionFlowLayout.minimumInteritemSpacing = space
            sentMemesCollectionFlowLayout.minimumLineSpacing = space
            sentMemesCollectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
    // MARK: TableView Actions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSavedMemes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell") as! MemeTableViewCell
        
        let savedMeme = savedMemeFor(indexPath: indexPath)
        cell.memeImageView.image = savedMeme.memedImage
        cell.topLabel.text = savedMeme.topText
        cell.bottomLabel.text = savedMeme.bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayMemeAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedMemes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: CollectionView Actions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSavedMemes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let savedMeme = savedMemeFor(indexPath: indexPath)
        cell.memeImageView.image = savedMeme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayMemeAt(indexPath: indexPath)
    }
    
    // MARK: Actions
    
    private func numberOfSavedMemes() -> Int {
        return savedMemes.count
    }
    
    private func savedMemeFor(indexPath: IndexPath) -> Meme {
        return savedMemes[indexPath.row]
    }
    
    private func displayMemeAt(indexPath: IndexPath) {
        let memeDisplayViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDisplayViewController") as! MemeDisplayViewController
        memeDisplayViewController.meme = savedMemeFor(indexPath: indexPath)
        
        navigationController?.pushViewController(memeDisplayViewController, animated: true)
    }
}

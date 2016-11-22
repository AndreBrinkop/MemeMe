//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 22.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: SentMemesViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var sentMemesCollectionView: UICollectionView?
    @IBOutlet var sentMemesCollectionFlowLayout: UICollectionViewFlowLayout?

    // MARK: Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

}

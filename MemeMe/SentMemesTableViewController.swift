//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by André Brinkop on 22.11.16.
//  Copyright © 2016 André Brinkop. All rights reserved.
//

import UIKit

class SentMemesTableViewController: SentMemesViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet var sentMemesTableView: UITableView?
    
    // MARK: Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sentMemesTableView = sentMemesTableView {
            sentMemesTableView.reloadData()
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

}

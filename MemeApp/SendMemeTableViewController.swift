//
//  SendMemeTableViewController.swift
//  MemeApp
//
//  Created by Juan Carlos Lopez on 11/24/16.
//  Copyright © 2016 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class SendMemeTableViewController:UITableViewController{
    
    var memes = [Meme]()
    
    let cellIdentifier = "memeTableViewCell"
    
    let attribute = [
        NSStrokeColorAttributeName:UIColor.black,
        NSForegroundColorAttributeName:UIColor.white,
        NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:20)!,
        NSStrokeWidthAttributeName:-3.0
        ] as [String:Any]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(gotoMemeViewController))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MemeTableViewCell
        
        let meme = self.memes[indexPath.row]
        cell.topText?.attributedText = NSAttributedString(string: meme.topText, attributes: attribute)
        cell.bottonText?.attributedText = NSAttributedString(string: meme.bottom, attributes: attribute)
        cell.name?.text = "\(meme.topText) \(meme.bottom)"
        cell.memeImage?.image = meme.image
        
        return cell
    }
    
    func gotoMemeViewController(){
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController")
        as! ViewController
        
        self.navigationController?.showDetailViewController(memeViewController, sender:self)
        
    }
}

//
//  SendMemeCollectionViewController.swift
//  MemeApp
//
//  Created by Juan Carlos Lopez on 11/23/16.
//  Copyright © 2016 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class SendMemeCollectionViewController:UICollectionViewController{
    var memes = [Meme]()
    let cellIdentifier = "MemeCollectionViewCell"
    var dimensionWidthLandPortraid:CGFloat!
    var dimensionWidthLandScape:CGFloat!
    let attribute = [
        NSStrokeColorAttributeName:UIColor.black,
        NSForegroundColorAttributeName:UIColor.white,
        NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:18)!,
        NSStrokeWidthAttributeName:-3.0
        ] as [String:Any]
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the collevtionView items size and space between rows a columns
        let space:CGFloat = 3.0
        self.dimensionWidthLandPortraid = ((self.collectionView?.frame.size.width)! - (2 * space)) / space
        self.dimensionWidthLandScape = ((self.collectionView?.frame.size.height)! - ( 4 * space)) / 5.0
        //let dimensionHeight = ((self.collectionView?.frame.size.width)! - (4 * space))/5.0
        
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.itemSize = CGSize(width: dimensionWidthLandPortraid , height: dimensionWidthLandPortraid)
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action:
                                                                 #selector(gotoMemeViewController))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        
        
        //Find beter way to reload the data when new item added
        self.collectionView?.reloadData()
        
        
    }

    
    func gotoMemeViewController(){
        let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! ViewController
        
        self.navigationController?.showDetailViewController(memeViewController, sender: self)
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:self.cellIdentifier , for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.top!.attributedText = NSAttributedString(string:meme.topText, attributes: attribute)
        cell.button!.attributedText = NSAttributedString(string:meme.bottom, attributes: attribute)
        cell.image!.image = meme.image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    override func viewWillLayoutSubviews() {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation){
            self.flowLayout.itemSize = CGSize(width: dimensionWidthLandScape, height: dimensionWidthLandScape)
        }else{
            self.flowLayout.itemSize = CGSize(width:dimensionWidthLandPortraid , height: dimensionWidthLandPortraid)
        }
    }
    
   
}

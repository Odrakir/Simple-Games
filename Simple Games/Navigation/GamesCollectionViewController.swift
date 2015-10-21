//
//  GamesCollectionViewController.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit

class GamesCollectionViewController: UICollectionViewController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gameCell", forIndexPath: indexPath) as? GameCell else { fatalError("Expected a `GameCell`.") }
        
        switch indexPath.row {
        case 0:
            //  cell.nameLabel.text = "The Wall"
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "theWall_cover")
        case 1:
            //  cell.nameLabel.text = "Columns"
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "columns_cover")
        case 2:
            //  cell.nameLabel.text = "Assault"
            cell.backgroundColor = UIColor.blueColor()
        default:
            break
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc:UIViewController
        
        switch indexPath.row {
        case 0:
            vc = UIViewController()
        case 1:
            vc = UIViewController()
        default:
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

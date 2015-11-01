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
        return 2
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gameCell", forIndexPath: indexPath) as? GameCell else { fatalError("Expected a `GameCell`.") }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "The Wall"
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "thewall")
        case 1:
            cell.titleLabel.text = "Columns"
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "columns")
            /*
        case 2:
            cell.titleLabel.text = "More soon..."
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "more_cover")
            */
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
            vc = GameViewController(game: Game.TheWall)
            /*
        case 1:
            vc = GameViewController(game: Game.Columns)
            */
        default:
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

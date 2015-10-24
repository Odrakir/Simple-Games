//
//  GameCell.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.alpha = 0.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.alpha = 0.0
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        /*
        Update the label's alpha value using the `UIFocusAnimationCoordinator`.
        This will ensure all animations run alongside each other when the focus
        changes.
        */
        coordinator.addCoordinatedAnimations({ [unowned self] in
            if self.focused {
                self.titleLabel.alpha = 1.0
            }
            else {
                self.titleLabel.alpha = 0.0
            }
            }, completion: nil)
    }
}

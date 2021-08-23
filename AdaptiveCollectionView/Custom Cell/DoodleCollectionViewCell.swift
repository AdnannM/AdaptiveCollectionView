//
//  DoodleCollectionViewCell.swift
//  AdaptiveCollectionView
//
//  Created by Adnann Muratovic on 23.08.21.
//

import UIKit

class DoodleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
        }
    }
}

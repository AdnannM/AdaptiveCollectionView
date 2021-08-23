//
//  SectionHeaderView.swift
//  AdaptiveCollectionView
//
//  Created by Adnann Muratovic on 23.08.21.
//

import UIKit

class SectionCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    
}

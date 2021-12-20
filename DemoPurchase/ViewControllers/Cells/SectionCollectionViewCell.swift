//
//  SectionCollectionViewCell.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 18.12.2021.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var llblSection: UILabel!
    @IBOutlet weak var bottomViewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomViewLine.isHidden = true
    }
    
    public func prepareView(sectionName: String?) {
        llblSection.text = sectionName ?? ""
    }
    
    override var isSelected: Bool {
        didSet {
            bottomViewLine.isHidden = !isSelected
        }
    }
    
    public func hideBottonLine(isHide: Bool) {
        bottomViewLine.isHidden = isHide
    }

}

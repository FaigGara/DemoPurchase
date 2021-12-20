//
//  SectionDetailCollectionViewCell.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 18.12.2021.
//

import UIKit

protocol SectionDetailCollectionViewCellDelegate {
    func didSelectProduct(_ product: Product)
    func sectionDetailCollectionViewCellTappedFree(_ product: Product)
}

class SectionDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: SectionDetailCollectionViewCellDelegate?
    
    var products: [Product]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "productListCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension SectionDetailCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate, let product = self.products?[indexPath.row] {
            delegate.didSelectProduct(product)
        }
    }
}

extension SectionDetailCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productListCell", for: indexPath) as! ProductCollectionViewCell
        cell.prepateDataSource(product: self.products![indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension SectionDetailCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width / 2 - 10, height: self.collectionView.frame.size.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension SectionDetailCollectionViewCell: ProductCollectionViewCellDelegate {
    func productCollectionViewCellTappedFree(view: ProductCollectionViewCell!, product: Product!) {
        if let d = self.delegate {
            d.sectionDetailCollectionViewCellTappedFree(product)
        }
    }
}

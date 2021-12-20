//
//  ProductCollectionViewCell.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 16.12.2021.
//

import UIKit

protocol ProductCollectionViewCellDelegate {
    func productCollectionViewCellTappedFree(view: ProductCollectionViewCell!, product: Product!)
}

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFree: UIButton!
    var product: Product?
    var delegate: ProductCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 10
        btnLike.layer.cornerRadius = 12.5
        btnFree.setImage(UIImage(named: "diamond"), for: .normal)
        btnFree.applyGradient(colours:[UIColor(red: 141.0/255, green: 125.0/255, blue: 223.0/255.0, alpha: 1), UIColor(red: 209.0/255, green: 104.0/255, blue: 121.0/255.0, alpha: 1)], locations: nil, cornerRadius: 12.5)
        btnLike.setTitle("", for: .normal)
        btnFree.setTitle("", for: .normal)
        btnFree.isHidden = true
    }
    
    public func prepateDataSource(product: Product?) {
        self.product = product
        if let isFree = product?.isFree {
            btnFree.isHidden = isFree
        }
        let wasLike = DataSaver.wasLikeThisProduct(self.product)
        
        if wasLike {
            self.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.btnLike.tintColor = .red
        }else {
            self.btnLike.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        if let imgUrlString = product?.templateCoverImageUrlString, let url = URL(string: imgUrlString) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.imgView.contentMode = .scaleToFill
                    self?.imgView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func btnFreeAction(_ sender: UIButton) {
        if let d = self.delegate, let p = self.product {
            d.productCollectionViewCellTappedFree(view: self, product: p)
        }
    }
    
    @IBAction func btnLikeAction(_ sender: Any) {
        guard let p = self.product else { return }
        let shouldAdd = DataSaver.shouldAddLikeForProducts(p: p)
        
        if shouldAdd {
            self.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.btnLike.tintColor = .red
        }else {
            self.btnLike.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
}

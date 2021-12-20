//
//  LikeProductsViewController.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 20.12.2021.
//

import UIKit

class LikeProductsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var products: [Product]?
    override func viewDidLoad() {
        super.viewDidLoad()
        products = DataSaver.products?.filter {
            DataSaver.wasLikeThisProduct($0)
        }
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "productListCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Beğeniler"
        self.tabBarController?.tabBar.isHidden = false
        products = DataSaver.products?.filter {
            DataSaver.wasLikeThisProduct($0)
        }
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }

}


extension LikeProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else { return }
        productDetailVC.product = products?[indexPath.row]
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension LikeProductsViewController: UICollectionViewDataSource {
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

extension LikeProductsViewController: UICollectionViewDelegateFlowLayout {
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

extension LikeProductsViewController: ProductCollectionViewCellDelegate {
    func productCollectionViewCellTappedFree(view: ProductCollectionViewCell!, product: Product!) {
        guard let subsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController else { return }
        subsVC.product = product
        subsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(subsVC, animated: true, completion: nil)
    }
}

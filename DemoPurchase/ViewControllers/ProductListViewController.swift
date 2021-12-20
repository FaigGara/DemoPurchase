//
//  ViewController.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 16.12.2021.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    var products: [Product]?
    var sections: [String]?
    var sectionCellSelectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "SectionDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "sectionDetailListCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        sectionCollectionView.register(UINib(nibName: "SectionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "sectionListCell")
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        
        title = ""
        prepareNavControllerLeftButton()
        prepareNavControllerRightButton()
        ServiceManager.shared.getProducts { products in
            if let prs = products, let sections = NSOrderedSet.init(array: prs.map { $0.section }).array as? [String] {
                self.products = prs
                DataSaver.products = prs
                self.sections = sections
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.sectionCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    private func prepareNavControllerRightButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        button.setTitle("Pro", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.setImage(UIImage(named: "diamond"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(tappedPro), for: .touchUpInside)
        button.applyGradient(colours:[UIColor(red: 141.0/255, green: 125.0/255, blue: 223.0/255.0, alpha: 1), UIColor(red: 209.0/255, green: 104.0/255, blue: 121.0/255.0, alpha: 1)], locations: nil, cornerRadius: 15)
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func tappedPro(sender: UIButton) {
        guard let subsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController else { return }
        subsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(subsVC, animated: true, completion: nil)
    }
    
    private func prepareNavControllerLeftButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "menu"), for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let index = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
            sectionCellSelectedIndex = index
            sectionCollectionView.reloadData()
        }
    }

}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.sectionCollectionView {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.sectionCellSelectedIndex = indexPath.row
            self.sectionCollectionView.reloadData()
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(self.collectionView == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionDetailListCell", for: indexPath) as! SectionDetailCollectionViewCell
            if let section = self.sections?[indexPath.row] {
                cell.products = self.products?.filter { $0.section == section }
            }
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionListCell", for: indexPath) as! SectionCollectionViewCell
            cell.prepareView(sectionName: self.sections![indexPath.row])
            if sectionCellSelectedIndex == indexPath.row {
                cell.hideBottonLine(isHide: false)
            }else {
                cell.hideBottonLine(isHide: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(self.collectionView == collectionView) {
            return CGSize(width: UIScreen.main.bounds.size.width, height: self.collectionView.frame.size.height)
        }else {
            if let font = UIFont(name: ".SFUI-Regular", size: 21) {
                let fontAttributes = [NSAttributedString.Key.font: font]
                let myText = self.sections![indexPath.row]
                let size = (myText as NSString).size(withAttributes: fontAttributes)
                return CGSize(width: size.width + 30, height: 40)
            }
            return CGSize(width: (self.sections![indexPath.row] as NSString).size(withAttributes: nil).width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ProductListViewController: SectionDetailCollectionViewCellDelegate {
    func didSelectProduct(_ product: Product) {
        guard let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else { return }
        productDetailVC.product = product
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func sectionDetailCollectionViewCellTappedFree(_ product: Product) {
        guard let subsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController else { return }
        subsVC.product = product
        subsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(subsVC, animated: true, completion: nil)
    }
}


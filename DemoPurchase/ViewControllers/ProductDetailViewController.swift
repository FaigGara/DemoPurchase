//
//  ProductDetailViewController.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 16.12.2021.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var product: Product?
    var heartButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editör"
        prepareViewComponents()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        prepateDataSource()
    }

    private func prepareViewComponents() {
        btnFree.layer.cornerRadius = 10
        prepareNavControllerRightButton()
    }
    
    private func prepareNavControllerRightButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(displayTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        heartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let wasLike = DataSaver.wasLikeThisProduct(self.product)
        if wasLike {
            heartButton!.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton!.tintColor = .red
        }else {
            heartButton!.setImage(UIImage(named: "heart"), for: .normal)
        }
        heartButton!.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        heartButton!.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        let heartBarButton = UIBarButtonItem(customView: heartButton!)
        navigationItem.rightBarButtonItems = [barButton, heartBarButton]
    }
    
    
    @objc func likeTapped(sender: UIButton) {
        guard let p = self.product else { return }
        let shouldAdd = DataSaver.shouldAddLikeForProducts(p: p)
        
        if shouldAdd {
            self.heartButton?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.heartButton?.tintColor = .red
        }else {
            self.heartButton?.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @objc func displayTapped(sender: UIButton) {
        guard let subsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController else { return }
        subsVC.product = product
        subsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(subsVC, animated: true, completion: nil)
    }
    
    public func prepateDataSource() {
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

}

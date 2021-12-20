//
//  Subscription ViewController.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 18.12.2021.
//

import UIKit

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var montlyView: UIView!
    @IBOutlet weak var yearlyView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnStarNow: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var lblMonthPrice: UILabel!
    
    @IBOutlet weak var lblWeekly: UILabel!
    @IBOutlet weak var lblWeeklyPrice: UILabel!
    
    @IBOutlet weak var lblYearly: UILabel!
    @IBOutlet weak var lblYearltPrice: UILabel!
    
    @IBOutlet weak var pricesView: UIStackView!
    
    let backView = UIView()
    
    var product: Product? {
        didSet {
            if let imgUrlString = product?.templateCoverImageUrlString, let url = URL(string: imgUrlString) {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [weak self] in
                        self?.imgView.contentMode = .scaleAspectFill
                        self?.imgView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapWeekly = UITapGestureRecognizer(target: self, action: #selector(weeklyViewTapped))
        
        let tapMonthly = UITapGestureRecognizer(target: self, action: #selector(montlyViewTapped))
        
        let tapYearly = UITapGestureRecognizer(target: self, action: #selector(yearlyViewTapped))
        
        weeklyView.addGestureRecognizer(tapWeekly)
        montlyView.addGestureRecognizer(tapMonthly)
        yearlyView.addGestureRecognizer(tapYearly)
        
        weeklyView.layer.cornerRadius = 10
        montlyView.layer.cornerRadius = 10
        yearlyView.layer.cornerRadius = 10
        
        montlyView.backgroundColor = .black
        lblMonthly.textColor = .white
        lblMonthPrice.textColor = .white
        
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.black.cgColor
        
        view.layoutSubviews()
        var frame = montlyView.frame
        frame.origin.x = frame.origin.x - 5
        frame.origin.y = pricesView.frame.origin.y
        frame.size.width = frame.size.width + 10
        frame.size.height = frame.size.height + 10
        backView.frame = frame
        bottomView.addSubview(backView)
    }
    
    @objc func weeklyViewTapped(sender: UITapGestureRecognizer) {
        weeklyView.backgroundColor = .black
        montlyView.backgroundColor = .white
        yearlyView.backgroundColor = .white
        
        lblWeekly.textColor = .white
        lblWeeklyPrice.textColor = .white
        lblMonthly.textColor = .black
        lblMonthPrice.textColor = .black
        lblYearly.textColor = .black
        lblYearltPrice.textColor = .black
        
        backView.frame.origin.x = pricesView.frame.origin.x + 8.5
        backView.frame.origin.y = pricesView.frame.origin.y - 1
    }
    
    @objc func montlyViewTapped(sender: UITapGestureRecognizer) {
        weeklyView.backgroundColor = .white
        montlyView.backgroundColor = .black
        yearlyView.backgroundColor = .white
        
        lblWeekly.textColor = .black
        lblWeeklyPrice.textColor = .black
        lblMonthly.textColor = .white
        lblMonthPrice.textColor = .white
        lblYearly.textColor = .black
        lblYearltPrice.textColor = .black
        
        let frame = montlyView.frame
        backView.frame.origin.x = frame.origin.x + 8.5
        backView.frame.origin.y = pricesView.frame.origin.y - 1
    }
    
    @objc func yearlyViewTapped(sender: UITapGestureRecognizer) {
        weeklyView.backgroundColor = .white
        montlyView.backgroundColor = .white
        yearlyView.backgroundColor = .black
        
        lblWeekly.textColor = .black
        lblWeeklyPrice.textColor = .black
        lblMonthly.textColor = .black
        lblMonthPrice.textColor = .black
        lblYearly.textColor = .white
        lblYearltPrice.textColor = .white
        
        let frame = yearlyView.frame
        backView.frame.origin.x = frame.origin.x + 8.5
        backView.frame.origin.y = pricesView.frame.origin.y - 1
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

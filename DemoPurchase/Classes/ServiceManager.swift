//
//  ServiceManager.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 16.12.2021.
//

import UIKit

struct Product: Codable {
    var _id: String
    var isFree: Bool
    var order: Int
    var canBeAssignedFullBackground: Bool
    var section: String
    var templateCoverImageUrlString: String
}

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    
    func getProducts(completionHandler: @escaping([Product]?) -> Void) {
        let urlString = "http://storly-dev.herokuapp.com/storly/api/templates"
        guard let uString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL(string: uString) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard error == nil else { return }
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let products = try decoder.decode([Product].self, from: responseData)
                completionHandler(products)
            } catch {
                completionHandler(nil)
            }
            
        }
        task.resume()
    }
}

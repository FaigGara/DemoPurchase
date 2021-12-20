//
//  DataSaver.swift
//  DemoPurchase
//
//  Created by Faig Garazade on 20.12.2021.
//

import Foundation

struct DataSaver {
    static let likeKey = "likeProducts"
    static var products: [Product]?
    
    static func saveDataWithUserDefaults(data: Any!, key: String!) {
        UserDefaults.standard.setValue(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getDataWithUserDefaults(key: String!) -> [String]? {
        return UserDefaults.standard.value(forKey: key) as? [String]
    }
    
    static func shouldAddLikeForProducts(p: Product!) -> Bool {
        guard let data = DataSaver.getDataWithUserDefaults(key: DataSaver.likeKey) else {
            DataSaver.saveDataWithUserDefaults(data: [p._id], key: DataSaver.likeKey)
            return true
        }
        
        if data.contains(p._id) {
            let datas = data.filter({ $0 != p._id })
            DataSaver.saveDataWithUserDefaults(data: datas, key: DataSaver.likeKey)
            return false
        }else {
            var newData = [String].init()
            newData.append(contentsOf: data)
            newData.append(p._id)
            DataSaver.saveDataWithUserDefaults(data: newData, key: DataSaver.likeKey)
            return true
        }
    }
    
    static func wasLikeThisProduct(_ product: Product?) -> Bool {
        
        guard let p = product else {
            return false
        }
        
        guard let data = DataSaver.getDataWithUserDefaults(key: DataSaver.likeKey) else {
            return false
        }
        if data.contains(p._id) {
            return true
        }
        return false
    }
    
}

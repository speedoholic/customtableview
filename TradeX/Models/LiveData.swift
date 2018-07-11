//
//  LiveData.swift
//  TradeX
//
//  Created by Kushal Ashok on 7/10/18.
//

import Foundation
import RealmSwift
import ObjectMapper

class LiveData: Object, Mappable, RealmObject {
    var coins = List<Coindata>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        coins <- (map["data"], ListTransform<Coindata>())
        self.save()
    }
}


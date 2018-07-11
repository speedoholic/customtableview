//
//  Coindata.swift
//  TradeX
//
//  Created by Kushal Ashok on 7/10/18.
//

import Foundation
import RealmSwift
import ObjectMapper

class Coindata: Object, Mappable, RealmObject {
    @objc dynamic var symbol = ""
    @objc dynamic var quoteAssetName = ""
    @objc dynamic var tradedMoney = ""
    @objc dynamic var baseAssetUnit = ""
    @objc dynamic var baseAssetName = ""
    @objc dynamic var baseAsset = ""
    @objc dynamic var tickSize = ""
    @objc dynamic var prevClose = ""
    @objc dynamic var activeBuy = ""
    @objc dynamic var high = ""
    @objc dynamic var lastAggTradeId = ""
    @objc dynamic var low = ""
    @objc dynamic var matchingUnitType = ""
    @objc dynamic var close = ""
    @objc dynamic var quoteAsset = ""
    @objc dynamic var productType = ""
    @objc dynamic var active = true
    @objc dynamic var minTrade = ""
    @objc dynamic var activeSell = ""
    @objc dynamic var withdrawFee = ""
    @objc dynamic var volume = ""
    @objc dynamic var decimalPlaces = ""
    @objc dynamic var quoteAssetUnit = ""
    @objc dynamic var open = ""
    @objc dynamic var status = ""
    @objc dynamic var minQty = ""
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    override class func primaryKey() -> String {
        return "symbol"
    }
    func mapping(map: Map) {
        symbol <- map["symbol"]
        baseAsset <- map["baseAsset"]
        quoteAsset <- map["quoteAsset"]
        tradedMoney <- map["tradedMoney"]
        volume <- map["volume"]
        high <- map["high"]
        low <- map["low"]
        self.update()
    }
}

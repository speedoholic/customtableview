//
//  Networkable.swift
//  ESV
//
//  Created by Kushal Ashok on 31/01/2018.
//

import UIKit
import Alamofire
import ObjectMapper

protocol NetworkTargetType {
    var baseURL: String { get }
    var urlPath: String { get }
    var method: Alamofire.HTTPMethod { get }
}

//Enum for all APIs
enum NetworkAPI {
    case getData()
}

enum CSMessage {
    case success(String)
    case fail(String)
}

extension NetworkAPI: NetworkTargetType {

    /// Base URL string
    var baseURL: String {
        switch self {
        case .getData:
            return BASEURL
        }
    }
    
    /// Request URL
    var urlPath: String {
        switch self {
        case .getData:
            return  baseURL + PRODUCTPATH
        }
    }
    /// Request method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getData:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getData:
            return ["Accept":"application/json"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getData:
            return JSONEncoding.default
        }
    }
    
    var errorMessage: String {
        switch self {
        case .getData:
            return DEFAULTERROR
        }
    }
    
}

protocol Requestable: class {
    func setupNetworkComponentWith<T: Mappable>(netapi: NetworkAPI, mapType: T.Type, mappedObjectHandle: ((_ object: T) -> Void)?, moreInfo: ((_ message: CSMessage) -> Void)?) -> Request
}
extension Requestable where Self: NSObject {
    /// NetworkComponent init
    func setupNetworkComponentWith<T: Mappable>(netapi: NetworkAPI, mapType: T.Type, mappedObjectHandle: ((_ object: T) -> Void )?, moreInfo: ((_ message: CSMessage) -> Void )?) -> Request {
        
        // start request address
        let request = Alamofire.request(netapi.urlPath, method: netapi.method , encoding: netapi.encoding, headers:netapi.headers ).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let responseJSON = value as? [String: Any] else {return}
                if let mapObject = Mapper<T>().map(JSON: responseJSON) {
                    mappedObjectHandle?(mapObject)
                    moreInfo?(CSMessage.success(""))
                } else {
                    moreInfo?(CSMessage.fail(DEFAULTERROR))
                }
            case .failure(let error):
                print("failure:" + error.localizedDescription)
                moreInfo?(CSMessage.fail(netapi.errorMessage))
            }
        }
        return request
    }
    
}


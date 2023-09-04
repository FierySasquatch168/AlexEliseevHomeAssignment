//
//  RequestCreator.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct RequestCreator {
    static func createGetRequest(endPoint: EndPointValue, query: QueryItems, item: Int) -> NetworkRequest {
        let url = URL(string: "\(endPoint.stringValue)\(query.stingValue)\(item)")
        return NetworkRequest(endPoint: url,
                              httpMethod: .get)
    }
    
    static func createSearchRequest(endPoint: EndPointValue, query: QueryItems, name: String) -> NetworkRequest {
        let url = URL(string: endPoint.stringValue + query.stingValue + name)
        return NetworkRequest(endPoint: url, httpMethod: .get)
    }
}

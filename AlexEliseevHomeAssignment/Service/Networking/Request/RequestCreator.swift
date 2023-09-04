//
//  RequestCreator.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct RequestCreator {
    static func createGetRequest(endPoint: EndPointValue, query: QueryItems, item: String) -> NetworkRequest {
        let url = URL(string: endPoint.stringValue + query.stringValue + item)
        return NetworkRequest(endPoint: url,
                              httpMethod: .get)
    }
}

//
//  NetworkRequest.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct NetworkRequest {
    let endPoint: URL?
    let httpMethod: HttpMethod
}

enum HttpMethod: String {
    case get = "GET"
}

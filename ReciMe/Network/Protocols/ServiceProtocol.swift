//
//  ServiceProtocol.swift
//
//  Created by Yeshua Lagac on 6/13/21.
//

import Foundation

typealias Headers = [String: String]
protocol ServiceProtocol {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    /// Setting this to `true` will add bearer token to url request header
    var needsAuthentication: Bool { get }
    /// Setting this to `true` will expect Data received will be enclosed with ServerResponse
    ///    - ServerResponse<T>
    ///    - =  { data: T , errors: [...] }
    var usesContainer: Bool { get }
    var parametersEncoding: ParametersEncoding { get }
}

extension ServiceProtocol {
    
    var baseURL: URL {
        return URL(string: "https://dev.api.recime.app/web-api/")!
    }
    
    var headers: Headers {
        var headers = [
            "Content-Type": "application/json"
        ]
        
        // This is token being handled if there's one
//        if needsAuthentication, let token = KeyChainAccessTokenManager.accessToken {
//            headers["Authorization"] = "Bearer \(token)"
//        }
        return headers
    }
}

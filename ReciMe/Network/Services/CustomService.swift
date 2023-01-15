//
//  CustomService.swift
//
//  Created by Yeshua Lagac on 10/21/21.
//

import Foundation

/// Use this to make custom services without adding another enum
struct CustomService: ServiceProtocol {
    
    var customBaseURL: URL? = nil
    var path = ""
    let method: HTTPMethod
    var task: Task = .requestPlain
    var needsAuthentication = false
    var usesContainer = false
    var parametersEncoding: ParametersEncoding = .url
    var showLogs = true
}

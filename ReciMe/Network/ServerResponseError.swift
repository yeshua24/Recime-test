//
//  ServerResponseError.swift
//
//  Created by Yeshua Lagac on 9/8/21.
//

import Foundation

struct ServerResponseError: Decodable {
    let error: ErrorResponse?
    
    private func getErrorDescription() -> String {
        if let error = error {
            return error.message
        }
        return NSLocalizedString("no errors", comment: "")
    }
}




//
//  RequestEnums.swift
//
//  Created by Yeshua Lagac on 6/13/21.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

typealias Parameters = [String: Any]

extension Parameters {
    static let serviceArrayOfParamsKey = "__array_of_params__"
}
extension Array where Element == [String: Any] {
    // Workaround for Array of Dictionaries
    // Can only be used in JSON type ParametersEncoding
    // WARNING: if we're actually going to have a `__array_of_params__`, this would produce problems
    var asServiceParameter: Parameters {
        return [Parameters.serviceArrayOfParamsKey: self]
    }
}

enum Task {
    case requestPlain
    case requestParameters(Parameters)
}

enum MultipartInput {
    case fileURL(URL)
    case data(Data, fileName: String)
    
    // TODO: refactor so that multipart inputs also accepts [String: Any] instead of [String: MultipartInput]
    case value(Any)
}

enum ParametersEncoding {
    case url
    case json
    case multipart
}

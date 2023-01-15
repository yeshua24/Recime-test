//
//  URLRequest+Extension.swift
//
//  Created by Yeshua Lagac on 6/13/21.
//

import Foundation
import CoreServices

extension URLRequest {

    init(service: ServiceProtocol) {
        let urlComponents = URLComponents(service: service)
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        
        service.headers.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        if service.parametersEncoding == .multipart,
                  case let .requestParameters(parameters) = service.task,
                  let multiPartParams = parameters as? [String: MultipartInput] {
            setValue("multipart/form-data; boundary=\(Data.boundary)", forHTTPHeaderField: "Content-Type")
            var contentLength = 0
            var httpBodyData = Data()
            
            multiPartParams.forEach { (key, multipartInput) in
                if case let .value(value) = multipartInput {
                    if let values = value as? [Any] {
                        values.forEach { one in
                            httpBodyData.appendValue(key: key, value: one)
                        }
                    } else {
                        httpBodyData.appendValue(key: key, value: value)
                    }
                } else {
                    var fileName: String? = nil
                    var data: Data? = nil
                    var multipartKey: String? = nil
                    
                    if case let .fileURL(fileURL) = multipartInput {
                        guard let fileData = try? Data(contentsOf: fileURL)
                        else {
                            print("Error || Invalid file data")
                            return
                        }
                        
                        fileName = fileURL.lastPathComponent
                        data = fileData
                        multipartKey = key
                        contentLength += fileData.count
                    } else if case let .data(fileData, fileName: inputFileName) = multipartInput {
                        fileName = inputFileName
                        data = fileData
                        multipartKey = key
                        contentLength += fileData.count
                    }
                    
                    if let fileName = fileName,
                       let data = data,
                       let multipartKey = multipartKey {
                        
                        httpBodyData.appendFileData(key: multipartKey, value: data, fileName: fileName)
                    } else {
                        print("ERROR || Multipart request requirements not met")
                    }
                }
            }
            
            httpBodyData.appendString("--\(Data.boundary)--\(Data.lineBreak)")
            httpBody = httpBodyData
            
            setValue(String(contentLength), forHTTPHeaderField: "Content-Length")
        } else if service.parametersEncoding == .json,
                  case let .requestParameters(parameters) = service.task {
            guard service.method != .get
            else {
                print("❌ ERROR ❌ || Blocked JSON request body. The service's method is `GET`. GET methods shouldn't have json bodies")
                return
            }
            var jsonObject: Any = parameters
            if let arrayOfDict = parameters[Parameters.serviceArrayOfParamsKey] {
                jsonObject = arrayOfDict
            }
            httpBody = try? JSONSerialization.data(withJSONObject: jsonObject)
            print("📦 Request parameters || \(service.path) \n \(jsonObject)")
        }
    }
    
}

extension Data {
    
    static var boundary = UUID().uuidString
    static var lineBreak = "\r\n"

    fileprivate mutating func appendFileData(key: String, value data: Data, fileName: String) {
        appendString("--\(Data.boundary + Data.lineBreak)")
        appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\(Data.lineBreak)")
        append(data)
        appendString(Data.lineBreak)
    }
    
    fileprivate mutating func appendValue(key: String, value: Any) {
        appendString("--\(Data.boundary + Data.lineBreak)")
        appendString("Content-Disposition: form-data; name=\"\(key)\"\(Data.lineBreak + Data.lineBreak)")
        appendString("\(value)")
        appendString(Data.lineBreak)
    }
    
    fileprivate mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension NSMutableData {
    
}

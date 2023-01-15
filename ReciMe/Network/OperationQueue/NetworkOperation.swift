//
//  NetworkOperation.swift
//
//  Created by Yeshua Lagac on 3/1/22.
//

import Foundation

final class NetworkOperation: AsyncOperation {
    
    private let session: URLSession
    
    private let request: URLRequest
    private var task: URLSessionTask?
    private let completion: (Data?, HTTPURLResponse?, Error?)->()
    
    init(session: URLSession, request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
        self.session = session
        self.request = request
        self.completion = completion
    }

    override func main() {
        attemptRequest()
    }
    
    private func attemptRequest() {
        task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            // I have a network manager using reachability but I removed it for now so no need to install any libraries
            // There's a condition here that if there's no network connection, it will fire a notification, but no need for now
            guard let httpResponse = response as? HTTPURLResponse
            else {
                self.completion(nil, nil, error)
                return
            }
            self.completion(data, httpResponse, error)
            self.finish()
        })
        task?.resume()
    }
    
    @objc func handleChangeInNetworkConnection() {
        print("Log || Operation resumed")
        self.attemptRequest()
        NotificationCenter.default.removeObserver(self)
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}

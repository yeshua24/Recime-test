//
//  URLImage.swift
//
//  Created by Yeshua Lagac on 12/24/22.
//

import SwiftUI
import Foundation

class ImageCache {
    static let shared: Cache<String, Data> = {
        let cacheFileName = "cached_images"
        let storedCache = Cache<String, Data>.fetchStoredCache(fileName: cacheFileName)
        let cache = storedCache ?? Cache<String, Data>(persists: true, cacheFileName: cacheFileName)
        cache.changeCountLimit(100)
        return cache
    }()
}

struct URLImage : View {
    
    enum PlaceholderImageType {
        case cover(size: CGFloat), user(size: CGFloat)
    }
    
    @StateObject private var remoteImage: RemoteImage
    var placeholder: PlaceholderImageType? = nil
    var tintColor: Color? = nil
    init(_ urlString: String?, placeholder: PlaceholderImageType? = nil, tintColor: Color? = nil) {
        _remoteImage = StateObject(wrappedValue: RemoteImage(urlString: urlString))
        self.placeholder = placeholder
        self.tintColor = tintColor
    }
    
    var body: some View {
        ZStack {
            switch remoteImage.loadingState {
            case .initial, .inProgress:
                Color.grey6.shimmering()
            case .success(let remoteImage):
                remoteImage
                    .renderingMode(tintColor == nil ? .original : .template)
                    .resizable()
                    .clipped()
                    .foregroundColor(tintColor)
            case .failure, .invalidImage:
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.grey4)
                    .saturation(0)
                    .overlay(
                        Group {
                            if let placeholder = self.placeholder {
                                switch placeholder {
                                case let .cover(size: size):
                                    Image(systemName:"photo.fill.on.rectangle.fill").resizable().scaledToFit().foregroundColor(.grey2)
                                        .frame(height: size)
                                case let .user(size: size):
                                    Image(systemName:"person.crop.circle.fill").resizable().scaledToFit().foregroundColor(.grey2)
                                        .frame(height: size)
                                }
                            } else {
                                Image(systemName:"exclamationmark.triangle.fill").resizable().scaledToFit().foregroundColor(.grey2)
                                    .frame(height: 40)
                            }
                        }

                    )
            }
        }
    }
}

extension URLImage {
    final class RemoteImage: NSObject, ObservableObject {
        
        enum LoadingState {
            case initial
            case inProgress
            case success(_ remoteImage: Image)
            case failure
            case invalidImage
        }
        
        let url: URL?
        var isGif: Bool = false
        let sessionProvider: URLSessionProvider
        
        @Published var loadingState: LoadingState = .initial
        var first = true
        
        init(urlString: String?, imageCache: Cache<String, Data> = ImageCache.shared, sessionProvider: URLSessionProvider = .shared) {
            if let urlString = urlString {
                self.url = URL(string: urlString)
            } else {
                url = nil
                loadingState = .failure
            }
            self.sessionProvider = sessionProvider
            super.init()
            load()
        }
        
        func load() {
            guard let url = url
            else {
                setLoadingState(to: .invalidImage)
                return
            }
            let cache = ImageCache.shared
            if let data = cache[url.absoluteString] {
                load(with: data)
            } else {
                setLoadingState(to: .inProgress)
                fetchImage(url: url)
            }
        }
        
        func load(with data: Data) {
            if let uiImage = UIImage(data: data) {
                loadingState = .success(.init(uiImage: uiImage))
            } else {
                loadingState = .failure
            }
        }
        
        func fetchImage(url: URL) {
            // Create Data Task
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("ERROR || Failed to fetch image \(error.localizedDescription)")
                    self.setLoadingState(to: .failure)
                } else if let data = data {
                    self.successHandler(data)
                }
                
            }
            dataTask.resume()
        }
        
        // TODO: handle if already loaded
        func successHandler(_ imageData: Data) {
            guard let url = url
            else {
                setLoadingState(to: .invalidImage)
                return
            }
            let urlString = url.absoluteString
            var dataToBeSaved: Data? = imageData
            if let uiImage = UIImage(data: imageData) {
                let compressedData = uiImage.compressToMaximumIfOver1MB()
                if let compressedData = compressedData,
                   let compressedUIImage = UIImage(data: compressedData) {
                    setLoadingState(to: .success(.init(uiImage: compressedUIImage)))
                    dataToBeSaved = compressedData
                } else {
                    setLoadingState(to: .success(.init(uiImage: uiImage)))
                }
            } else {
                setLoadingState(to: .invalidImage)
                dataToBeSaved = nil
            }
            if let dataToBeSaved = dataToBeSaved {
                ImageCache.shared.insert(dataToBeSaved, forKey: urlString)
            }
            saveImagesToDisk()
        }
        
        func setLoadingState(to state: LoadingState) {
            withAnimation {
                DispatchQueue.main.async {
                    self.loadingState = state
                }
            }
        }
        
        private func saveImagesToDisk() {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(_saveImagesToDisk), object: nil)
            self.perform(#selector(self._saveImagesToDisk), with: nil, afterDelay: 2)
        }
        
        @objc private func _saveImagesToDisk() {
            do {
                try ImageCache.shared.saveToDisk()
            } catch let error {
                print("ERROR || Failed to save image cache to disk |", error)
            }
        }
    }

}

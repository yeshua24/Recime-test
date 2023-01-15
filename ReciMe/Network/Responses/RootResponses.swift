
import Foundation

typealias result<T> = (Result<T, APIServiceError>) -> Void
typealias response<T> = Result<T, APIServiceError>

struct EmptyObject: Decodable { }
struct ErrorDetailResponse: Decodable { let detail: String }
struct ErrorMessageResponse: Decodable { let message: String }

struct ResponseResponse: Decodable { let response: String }

struct ErrorsResponse: Decodable {
    let error: String?
    let message: [String]
    let statusCode: Int?
}

struct ErrorResponse: Decodable {
    let error: String?
    let message: String
    let statusCode: Int?
}

struct PageInfo: Decodable {
    let nextLink: String?
    let previousLink: String?
    
    enum CodingKeys: String, CodingKey {
        case nextLink = "next", previousLink = "previous"
    }
}

/**
 A marker struct intended to replace regular Array Types (eg: [SomeDecodable].self) inside URLSessionProvider.request
*/
struct CleanArray<T: Decodable> { }

struct ServerResponse<Element: Decodable>: Decodable {
    
    let pageInfo: PageInfo?
    let data: Element?
    var error: ErrorResponse? = nil
    
    enum CodingKeys: String, CodingKey {
        case pageInfo, data, error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageInfo = try? container.decode(PageInfo.self, forKey: .pageInfo)
        data = try container.decode(Element.self, forKey: .data)
        error = try container.decode(ErrorResponse.self, forKey: .error)
    }
    
    init(pageInfo: PageInfo?,
         data: Element?,
         error: ErrorResponse?) {
        self.pageInfo = pageInfo
        self.data = data
        self.error = error
    }
    
    private func getErrorDescription() -> String {
        if let error = error {
            return error.message
        }
        return NSLocalizedString("no errors", comment: "")
    }
}




import Foundation

enum APIServiceError: Error {
    case apiReturnError(_ error: ErrorResponse)
    case apiReturnErrors(_ errors: ErrorsResponse?)
    case apiError(Int)
    case invalidToken
    case noData
    case noResponse
    case noDataInContainer
    case decodeError(Error?)
    case requestError(error: Error)
    case unsupportedDataError
    
    func getDescription() -> String{
        switch self {
        case .apiError:
            return "Something went wrong. Try again later."
        case .invalidToken:
            return "Looks like there's a problem with your Authentication"
        case .requestError(let err):
            return "\(err.localizedDescription)"
        case .unsupportedDataError:
            return "Response contained an unknown error"
        case .noData:
            return "No data was received"
        case .noResponse:
            return "No response received"
        case .noDataInContainer:
            return "No data found in the Response Container"
        case .decodeError:
            return "Invalid data received."
        case .apiReturnError(let error):
            return error.message
        case .apiReturnErrors(let errors):
            return errors?.message.compactMap({$0}).joined(separator: "\n") ?? ""
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .apiError(let code):
            return code
        case .apiReturnError(let error):
            return error.statusCode
        default:
            return nil
        }
    }
}

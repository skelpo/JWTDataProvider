import Vapor
import HTTP

public enum JSONError: Error, AbortError {
    case noAccessToken(String)
    
    public var identifier: String {
        switch self {
        case .noAccessToken: return "noAccessToken"
        }
    }
    
    public var reason: String {
        switch self {
        case let .noAccessToken(url): return "No access token was found for service accesing enpoint '\(url)'. Did you forget to pass one in?"
        }
    }
    
    public var status: HTTPStatus {
        return .internalServerError
    }
}

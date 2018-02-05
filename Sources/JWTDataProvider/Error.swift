import Vapor
import HTTP

public enum JSONError: Error, AbortError {
    case duplicateKey
    case badJSONStructure
    case noAccessToken(String)
    
    public var identifier: String {
        switch self {
        case .duplicateKey: return "duplicateKey"
        case .badJSONStructure: return "badJSONStructure"
        case .noAccessToken: return "noAccessToken"
        }
    }
    
    public var reason: String {
        switch self {
        case .duplicateKey: return "A duplicate key was found when merging JSON objects"
        case .badJSONStructure: return "Make sure you are adding the new keys to a JSON object, and not a value or array"
        case let .noAccessToken(url): return "No access token was found for service accesing enpoint '\(url)'. Did you forget to pass one in?"
        }
    }
    
    public var status: HTTPStatus {
        return .internalServerError
    }
}

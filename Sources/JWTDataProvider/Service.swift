import Vapor
@_exported import JSONKit

extension Data: Content {}

public protocol DataService: Service {
    var url: String { get }
    var method: HTTPMethod { get }
    var body: Data { get }
    var headers: HTTPHeaders { get }
    var requiresAccessToken: Bool { get }
    var jsonPath: [String] { get }
    var `default`: JSON { get }
}

extension DataService {
    public var method: HTTPMethod {
        return .GET
    }
    
    public var body: Data {
        return Data()
    }
    
    public var headers: HTTPHeaders {
        return [:]
    }
    
    public var requiresAccessToken: Bool {
        return false
    }
    
    public var jsonPath: [String] {
        return []
    }
    
    public var `default`: JSON {
        return nil
    }
}

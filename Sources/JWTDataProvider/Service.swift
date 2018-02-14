import Vapor
@_exported import JSON

public protocol DataService: Service {
    var url: String { get }
    var method: HTTPMethod { get }
    var body: HTTPBody { get }
    var headers: HTTPHeaders { get }
    var requiresAccessToken: Bool { get }
    var jsonPath: [String] { get }
    var `default`: JSON { get }
}

extension DataService {
    public var method: HTTPMethod {
        return .get
    }
    
    public var body: HTTPBody {
        return HTTPBody()
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

extension HTTPBody: HTTPBodyRepresentable {
    public func makeBody() throws -> HTTPBody {
        return self
    }
}

extension HTTPBody: Content {}

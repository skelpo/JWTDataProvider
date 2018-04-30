import Vapor
@_exported import JSONKit

extension Data: Content {}

public struct RemoteDataClient: Service {
    public var url: String
    public var method: HTTPMethod
    public var body: Data
    public var headers: HTTPHeaders
    public var requiresAccessToken: Bool
    public var jsonPath: [String]
    public var `default`: JSON
    
    public init(url: String, method: HTTPMethod = .GET, body: Data = Data(), headers: HTTPHeaders = [:], requiresAccessToken: Bool = false, jsonPath: [String] = [], default: JSON = nil) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.requiresAccessToken = requiresAccessToken
        self.jsonPath = jsonPath
        self.default = `default`
    }
}

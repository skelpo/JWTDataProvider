import Vapor
@_exported import JSONKit

extension Data: Content {}

public struct DataService: Service {
    var url: String
    var method: HTTPMethod
    var body: Data
    var headers: HTTPHeaders
    var requiresAccessToken: Bool
    var jsonPath: [String]
    var `default`: JSON
    
    init(url: String, method: HTTPMethod = .GET, body: Data = Data(), headers: HTTPHeaders = [:], requiresAccessToken: Bool = false, jsonPath: [String] = [], default: JSON = nil) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.requiresAccessToken = requiresAccessToken
        self.jsonPath = jsonPath
        self.default = `default`
    }
}

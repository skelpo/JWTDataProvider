import Service
import HTTP
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

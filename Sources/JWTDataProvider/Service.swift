import HTTP
import JSON

internal struct Service: Decodable {
    let name: String
    let data: ServiceData
}

internal struct ServiceData: Decodable {
    let url: String
    let method: HTTPMethod
    let body: JSON
    let header: [HTTPHeaderName: String]
    let requiresAccessToken: Bool
    let filter: String
    let `default`: Codable?
}

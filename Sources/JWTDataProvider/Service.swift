import HTTP
import JSON

internal struct Services: Decodable {
    let services: [String: ServiceData]

    var all: [Service] {
        return self.services.map { (name, data)
            return Service(name: name, data: data)
        }
    }
}

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

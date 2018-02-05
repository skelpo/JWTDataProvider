import HTTP
import Vapor
import JSON

final internal class DataServiceContainer: Service {
    var services: [DataService] = []
    
    init() {}
}

internal struct DataServices: Decodable {
    let services: [String: ServiceData]

    var all: [DataService] {
        return self.services.map { (name, data) in
            return DataService(name: name, data: data)
        }
    }
}

internal struct DataService: Decodable {
    let name: String
    let data: ServiceData
}

internal struct ServiceData: Codable {
    let url: String
    let method: HTTPMethod
    let body: HTTPBody
    let headers: HTTPHeaders
    let requiresAccessToken: Bool
    let filter: String
    let `default`: JSON?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ServiceData.CodingKeys.self)
        
        self.url = try container.decode(String.self, forKey: .url)
        self.method = try container.decodeIfPresent(HTTPMethod.self, forKey: .method) ?? .get
        self.body = try container.decodeIfPresent(HTTPBody.self, forKey: .body) ?? HTTPBody()
        self.headers = try container.decodeIfPresent(HTTPHeaders.self, forKey: .headers) ?? [:]
        self.requiresAccessToken = try container.decodeIfPresent(Bool.self, forKey: .requiresAccessToken) ?? false
        self.filter = try (container.decodeIfPresent(Array<String>.self, forKey: .filter) ?? []).joined(separator: ".")
        self.default = try container.decodeIfPresent(JSON.self, forKey: .default) ?? .null
    }
}

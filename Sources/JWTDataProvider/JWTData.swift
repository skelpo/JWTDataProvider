import Vapor
import JSONKit
import Foundation

extension Request {
    public func fetch<Payload>(
        _ accessToken: String? = nil,
        with parameters: [String: String] = [:],
        as payloadType: Payload.Type = Payload.self
    )throws -> Future<Payload> where Payload: Codable {
        let client = try self.make(Client.self)
        let serviceContainer = try self.make(JWTDataConfig.self)
        var body: JSON = [:]
        
        return try serviceContainer.dataServices.map({ (name, data) in
            let url = URI(replace(placeholders: parameters, in: data.url))
            var headers = data.headers

            if data.requiresAccessToken && headers[.authorization] == nil {
                guard let token = accessToken else {
                    throw JWTDataError.noAccessToken(url.rawValue)
                }
                headers[.authorization] = "Bearer \(token)"
            }

            let httpRequest = HTTPRequest(method: data.method, uri: url, headers: headers, body: data.body)
            let request = Request(http: httpRequest, using: self.superContainer)
            
            return try client.respond(to: request).flatMap(to: JSON.self, { (response) in
                return try response.content.decode(JSON.self)
            }).map(to: Void.self) { content in
                try body.set(name, content)
            }.catchMap() { _ in
                try body.set(name, data.default)
            }
        }).flatten().map(to: Payload.self) { _ in
            return try Payload(json: body)
        }
    }
}

fileprivate func replace(placeholders: [String: String], `in` string: String) -> String {
    var str = string
    for (name, value) in placeholders {
        str = str.replacingOccurrences(of: "{\(name)}", with: value)
    }
    return str
}

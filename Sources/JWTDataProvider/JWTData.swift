import Vapor
import JSONKit
import Foundation

extension Request {
    public func payloadData<Payload>(
        _ accessToken: String? = nil,
        with parameters: [String: String] = [:],
        as payloadType: Payload.Type = Payload.self
    )throws -> Future<Payload> where Payload: Codable {
        let client = try self.make(Client.self)
        let serviceContainer = try self.make(JWTDataConfig.self)
        var body: JSON = [:]
        
        return try serviceContainer.dataServices.map({ (name, data) in
            var headers = data.headers

            if data.requiresAccessToken && headers[.authorization].first == nil {
                guard let token = accessToken else {
                    throw JWTDataError.noAccessToken(data.url.replacing(placeholders: parameters))
                }
                headers.replaceOrAdd(name: .authorization, value: "Bearer \(token)")
            }
            
            let response = client.send(data.method, headers: headers, to: data.url.replacing(placeholders: parameters), content: data.body)
            return response.flatMap(to: JSON.self, { (response) in
                return try response.content.decode(JSON.self)
            }).map(to: Void.self) { content in
                try body.set(name, content.element(at: data.jsonPath))
            }.catchMap() { _ in
                try body.set(name, data.default)
            }
        }).flatten(on: self).map(to: Payload.self) { _ in
            return try Payload(json: body)
        }
    }
}

extension String {
    internal func replacing(placeholders: [String: String]) -> String {
        var str = self
        for (name, value) in placeholders {
            str = str.replacingOccurrences(of: "{\(name)}", with: value)
        }
        return str
    }
}

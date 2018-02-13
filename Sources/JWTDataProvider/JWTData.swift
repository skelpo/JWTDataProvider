import Vapor
import JSONKit
import Foundation

typealias EndpointResult = (name: String, response: Response)
typealias ParsedEndpoint = (name: String, json: JSON)

extension Request {
    public func fetch<Payload>(
        _ accessToken: String? = nil,
        with parameters: [String: String] = [:],
        as payloadType: Payload.Type = Payload.self
    )throws -> Future<Payload> where Payload: Codable {
        let client = try self.make(Client.self)
        let serviceContainer = try self.make(JWTDataConfig.self)
        
        return try serviceContainer.dataServices.map({ (name, data) -> Future<EndpointResult> in
            guard let url: URI = URI(rawValue: replace(placeholders: parameters, in: data.url)) else {
                throw JWTDataError.badURL(type(of: serviceContainer.dataServices[name]!))
            }
            var headers = data.headers

            if data.requiresAccessToken && headers[.authorization] == nil {
                if let token = accessToken {
                    headers[.authorization] = token
                } else {
                    throw JWTDataError.noAccessToken(url.rawValue)
                }
            }

            let httpRequest = HTTPRequest(method: data.method, uri: url, headers: headers, body: data.body)
            let request = Request(http: httpRequest, using: self.superContainer)
            
            return try client.respond(to: request).map(to: EndpointResult.self, { (response) -> EndpointResult in
                return (name: name, response: response)
            })
        }).flatten().flatMap(to: [ParsedEndpoint].self) { (results) -> Future<[ParsedEndpoint]> in
            return try results.map({ (result) -> Future<ParsedEndpoint> in
                return try result.response.content.decode(JSON.self).map(to: ParsedEndpoint.self) { json in
                    return (name: result.name, json: json)
                }
            }).flatten()
        }.map(to: Payload.self) { endpoints in
            let body = endpoints.reduce(into: [:], { (structure, line) in
                structure[line.name] = line.json
            })
            let json = JSON.object(body)
            return try Payload(json: json)
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

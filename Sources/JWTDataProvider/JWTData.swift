import Vapor
import JWT
import HTTP
import JSON
import Foundation

extension Request {
    public func fetch<Payload>(
        _ accessToken: String? = nil,
        with parameters: [String: String],
        as payloadType: Payload.Type
    )throws -> Future<Payload> where Payload: JWTPayload {
        let result = Promise(Payload.self)
        let client = try self.make(Client.self)
        let serviceContainer = try self.make(DataServiceContainer.self)
        
        var responses: [Future<Response>] = []
        var names: [String] = []
        
        try serviceContainer.services.forEach({ service in
            var header = service.data.headers
            let url = replace(placeholders: parameters, in: service.data.url)
            
            if service.data.requiresAccessToken {
                if accessToken != nil && header[.authorization] == nil {
                    header[.authorization] = "Bearer \(accessToken!)"
                } else {
                    result.fail(JSONError.noAccessToken(url))
                    print("[JWTDataProvider - Bad API Usage: \(Date())] No access token passed in for service '\(service.name)' requiring access token.")
                    return
                }
            }
            
            let httpRequest = HTTPRequest(
                method: service.data.method,
                uri: URI(url),
                headers: service.data.headers,
                body: service.data.body
            )
            let request = Request(http: httpRequest, using: self.superContainer)
            let response = try client.respond(to: request)
            
            responses.append(response)
            names.append(service.name)
        })
        
        return responses.flatten().flatMap(to: [JSON].self) { (reses)  in
            return try reses.map({ (response) in
                return try response.content.decode(JSON.self)
            }).flatten()
        }.map(to: JSON.self) { (objects) in
            var data: [String: JSON] = [:]
            
            zip(names, objects).forEach({ (serviceResult) in
                let (name, object) = serviceResult
                data[name] = object
            })
            
            return JSON.object(data)
        }.flatMap(to: Payload.self) { (json) in
            let data = try JSONEncoder().encode(json)
            try result.complete(JSONDecoder().decode(Payload.self, from: data))
            return result.future
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

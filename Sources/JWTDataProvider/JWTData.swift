import Vapor
import JWT
import HTTP

public final class JWTData {
    public static func fetch(_ accessToken: String? = nil, parameters: [String: String])throws -> JSON {
        var payload = JSON()
        
        try services.forEach({ service in
            var header = service.header
            let url = JWTData.replace(placeholders: parameters, in: service.url)
            
            if service.requiresAccessToken && accessToken != nil && header[.authorization] == nil {
                header[.authorization] = "Bearer \(accessToken!)"
            }
            
            let response = try drop.client.request(
                                    service.method,
                                    url,
                                    header,
                                    service.body
                                )
            if let json = response.json {
                let value: Node = try json.get(service.filter)
                try payload.set(service.name, value)
            } else {
                try payload.set(service.name, service.default)
            }
        })
        
        return payload
    }

    fileprivate static func replace(placeholders: [String: String], `in` string: String) -> String {
        var str = string
        for (name, value) in placeholders {
            str = str.replacingOccurrences(of: "{\(name)}", with: value)
        }
        return str
    }
}

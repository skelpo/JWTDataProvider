import Vapor
import JWT

public final class JWTData {
    public static func fetch()throws -> JSON {
        var payload = JSON()
        
        try services.forEach({ service in
            let response = try drop.client.request(service.method, service.url)
            if let json = response.json {
                try payload.set(service.name, json)
            } else {
                try payload.set(service.name, response.body.bytes)
            }
        })
        
        return payload
    }
}

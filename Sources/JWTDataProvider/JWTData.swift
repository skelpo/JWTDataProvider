import Vapor
import JWT
import HTTP

public final class JWTData {
    public static func fetch(_ accessToken: String? = nil)throws -> JSON {
        var payload = JSON()
        
        try services.forEach({ service in
            var serve = service
            
            if serve.requiresAccessToken && accessToken != nil && serve.header[.authorization] == nil {
                serve.header[.authorization] = "Bearer \(accessToken!)"
            }
            
            let response = try drop.client.request(
                                    serve.method,
                                    serve.url,
                                    serve.header,
                                    serve.body
                                )
            if let json = response.json {
                try payload.set(serve.name, json)
            } else {
                try payload.set(serve.name, response.body.bytes)
            }
        })
        
        return payload
    }
}

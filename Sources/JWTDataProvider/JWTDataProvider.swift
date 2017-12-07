import Vapor
import HTTP

internal private(set) var services: [Service] = []

public final class Provider: Vapor.Provider {
    public static var repositoryName: String = "JWTDataProvider"
    
    public func boot(_ config: Config) throws {
        guard let service = config["service"] else {
            throw ConfigError.missingFile("service.json")
        }
        
        guard let jsonServices = service["services"]?.array else {
            throw ConfigError.missing(key: ["services"], file: "service.json", desiredType: Array<Service>.self)
        }
        
        services = try jsonServices.map { (json) -> Service in
            guard let name = json["name"]?.string,
                  let url = json["url"]?.string else {
                    throw ConfigError.missing(key: ["name", "url"], file: "service.json", desiredType: String.self)
            }
            
            let method = json["method"]?.string ?? "get"
            let httpMethod = HTTP.Method.init(method)
            
            return Service(name: name, url: url, method: httpMethod)
        }
    }
    
    public func boot(_ droplet: Droplet) throws {}
    public func beforeRun(_ droplet: Droplet) throws {}
    public init(config: Config) throws {}
}


import Vapor
import HTTP

internal private(set) var services: [Service] = []
internal private(set) var drop: Droplet!

public final class Provider: Vapor.Provider {
    public static var repositoryName: String = "JWTDataProvider"
    
    public func boot(_ config: Config) throws {
        guard let service = config["service"] else {
            throw ConfigError.missingFile("service.json")
        }
        
        guard let jsonServices = service["services"]?.object else {
            throw ConfigError.missing(key: ["services"], file: "service.json", desiredType: Array<Service>.self)
        }
        
        services = try jsonServices.map({ (key, config) -> Service in
            guard let url = config["url"]?.string else {
                    throw ConfigError.missing(key: ["url"], file: "service.json", desiredType: String.self)
            }
            let method = HTTP.Method.init(config["method"]?.string ?? "get")
            let body = try JSON(node: config["body"])
            let requiresAccessToken = config["requires_access_token"]?.bool ?? false
            let headers = createHeader(config)
            let filterConfigs = config["filters"]?.array
            let filters = filterConfigs?.map({ $0.string }).filter({ $0 != nil }).map({ $0! }) ?? []
            let jsonFilter = filters.joined(separator: ".")
            
            return Service(name: key, url: url, method: method, body: body, header: headers, requiresAccessToken: requiresAccessToken, filter: jsonFilter)
        })
    }
    
    public func boot(_ droplet: Droplet) throws {
        drop = droplet
    }
    
    public func beforeRun(_ droplet: Droplet) throws {}
    public init(config: Config) throws {}
}


fileprivate func createHeader(_ config: Config) -> [HeaderKey: String] {
    var headers: [HeaderKey: String] = [:]
    config["headers"]?.object?.forEach({ (key, value) in
        headers[HeaderKey(key)] = value.string
    })
    return headers
}

import Service

public struct JWTDataConfig: ServiceType {
    var dataServices: [String: DataService]
    
    public init(_ services: [String: DataService] = [:]) {
        self.dataServices = services
    }
    
    public mutating func add(service: DataService, named name: String) {
        self.dataServices[name] = service
    }
    
    public static func makeService(for worker: Container) throws -> JWTDataConfig {
        return JWTDataConfig()
    }
}

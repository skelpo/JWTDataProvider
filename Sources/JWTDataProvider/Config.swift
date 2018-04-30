import Service

public struct JWTDataConfig: ServiceType {
    var dataServices: [String: RemoteDataClient]
    
    public init(_ services: [String: RemoteDataClient] = [:]) {
        self.dataServices = services
    }
    
    public mutating func add(service: RemoteDataClient, named name: String) {
        self.dataServices[name] = service
    }
    
    public static func makeService(for worker: Container) throws -> JWTDataConfig {
        return JWTDataConfig()
    }
}

import Service

public struct JWTDataConfig: Service {
    var dataServices: [String: DataService]
    
    public init(_ services: [String: DataService] = [:]) {
        self.dataServices = services
    }
    
    public mutating func add(service: DataService, named name: String) {
        self.dataServices[name] = service
    }
}

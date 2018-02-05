import Vapor
import HTTP
import Foundation

public final class Provider: Vapor.Provider {
    public static var repositoryName: String = "JWTDataProvider"

    /// Register all services provided by the provider here.
    public func register(_ services: inout Services) throws {
        services.register(isSingleton: true) { (container) -> (DataServiceContainer) in
            return DataServiceContainer()
        }
    }

    /// Called after the container has initialized.
    public func boot(_ worker: Container) throws {
        let container = try worker.make(DataServiceContainer.self, for: Container.self)
        let file = File(on: worker)
        let decoder = JSONDecoder()
        let root = DirectoryConfig.detect().workDir
        
        _ = file.read(at: root + "/Config/services.json", chunkSize: 16384).map(to: Void.self) { (data) in
            container.services = try decoder.decode(DataServices.self, from: data).all
        }
    }
}

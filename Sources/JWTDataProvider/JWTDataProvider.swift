import Vapor
import HTTP
import Foundation

internal private(set) var services: [Service] = []
internal private(set) var client: ClientFactoryProtocol!

public final class Provider: Vapor.Provider {
    public static var repositoryName: String = "JWTDataProvider"

    /// Register all services provided by the provider here.
    public func register(_ services: inout Services) throws {}

    /// Called after the container has initialized.
    public func boot(_ worker: Container) throws {
        let file = File(on: worker)
        let decoder = JSONDecoder()
        let root = DirectoryConfig.detect().workDir
        
        file.read(at: root + "/Config/services.json", chunkSize: 16384).map(to: Services.self) { (data) in
            services = decoder.decode(Services.self, from: data).all
        }
    }
}

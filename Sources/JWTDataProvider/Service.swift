import HTTP
import JSON

internal struct Service {
    internal let name: String
    internal let url: String
    internal let method: Method
    internal let body: JSON
    internal let header: [HeaderKey: String]
    internal let requiresAccessToken: Bool
    internal let filter: String
    internal let `default`: Node
    
}

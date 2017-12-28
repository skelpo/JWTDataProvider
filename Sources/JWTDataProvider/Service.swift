import HTTP
import JSON

internal struct Service {
    let name: String
    let url: String
    let method: Method
    let body: JSON
    let header: [HeaderKey: String]
    let requiresAccessToken: Bool
    let filter: String
    let `default`: Node
}

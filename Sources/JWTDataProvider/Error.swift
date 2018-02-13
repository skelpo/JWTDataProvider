import Vapor
import Debugging

public struct JWTDataError: Debuggable, AbortError {
    public let identifier: String
    public let reason: String
    public let status: HTTPStatus
}

extension JWTDataError {
    public static func noAccessToken(_ url: String) -> JWTDataError {
        return self.init(
            identifier: "noAccessToken",
            reason: "No access token was found for service accesing enpoint '\(url)'. Did you forget to pass one in?",
            status: .internalServerError
        )
    }
}

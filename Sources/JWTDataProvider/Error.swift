public enum JWTDataProviderError: Error, CustomStringConvertible {
    case badFilterKey(String)
    
    public var description: String {
        switch self {
        case let .badFilterKey(key): return "No key '\(key)' found in JSON"
        }
    }
}

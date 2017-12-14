import JSON

public enum JSONError: Error, CustomStringConvertible {
    case duplicateKey
    case badJSONStructure
    
    public var description: String {
        switch self {
        case .duplicateKey: return "A duplicate key was found when merging JSON objects"
        case .badJSONStructure: return "Make sure you are adding the new keys to a JSON object, and not a value or array"
        }
    }
}

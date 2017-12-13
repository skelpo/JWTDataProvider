import JSON

internal final class JSONFilter {
    let keys: [String]
    
    init(keys: [String]) {
        self.keys = keys
    }
    
    func filter(json: JSON)throws -> Any {
        return try self.filter(json: json, with: self.keys)
    }
    
    private func filter(json: JSON, with keys: [String])throws -> Any {
        var value: Any = json
        var keysLeft = keys
        
        while keysLeft.count > 0 {
            let key = keysLeft[0]
            if let val = value as? JSON {
                value = try val.get(key)
            } else if let val = value as? [JSON] {
                return try val.map({ json in
                    return try self.filter(json: json, with: keysLeft)
                })
            } else {
                throw JWTDataProviderError.badFilterKey(key)
            }
            keysLeft = Array(keysLeft.dropFirst())
        }
        
        return value
    }
}

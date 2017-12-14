import JSON

extension JSON {
    public func mergeFetch(with paramaters: [String: String], _ accessToken: String? = nil)throws -> JSON {
        let merger = try JWTData.fetch(accessToken, parameters: paramaters)
        return try self.merge(merger)
    }
    
    public func merge(_ json: JSON)throws -> JSON {
        guard case let StructuredData.object(this) = self.wrapped else {
            throw JSONError.badJSONStructure
        }
        guard case let StructuredData.object(new) = json.wrapped else {
            throw JSONError.badJSONStructure
        }
        let data = try this.merging(new, uniquingKeysWith: { (one, two) -> StructuredData in
            throw JSONError.duplicateKey
        })
        return JSON(data)
    }
}

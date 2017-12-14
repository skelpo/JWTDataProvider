import XCTest
import JSON
@testable import JWTDataProvider

class JWTDataProviderTests: XCTestCase {
    func testExample() {
        let bytes = """
        {
            "foo": "bar"
        }
        """.makeBytes()
        
        let data2 = """
        {
            "click": 45
        }
        """.makeBytes()
        
        do {
            let one = try JSON(bytes: bytes)
            let two = try JSON(bytes: data2)
            let json = try one.merge(two)
            let serelized = try json.serialize(prettyPrint: true).makeString()
            print(serelized)
        } catch let error {
            print("Error: ", error)
            XCTFail()
        }
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}

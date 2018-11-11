import App
import Vapor
import XCTest

final class SampleRouteTests: BaseTestCase {

    func testSampelRoute() throws {
        let response = try? app.client().get("http://localhost:8080").wait()
        XCTAssert(response?.http.status == .ok)
    }

    static let allTests = [
        ("testSampelRoute", testSampelRoute)
    ]
}

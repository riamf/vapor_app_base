import App
import Vapor
import XCTest
import FluentMySQL
@testable import App

final class BasicRouteTests: BaseTestCase {

    func testSecureRouteWithoutUser() {
        let response = try! app.client().get("http://localhost:8080/users").wait()
        XCTAssert(response.http.status == .unauthorized)
    }

    func testSecureRouteWithUser() {

        let uuid = UUID().uuidString
        let password = "secure"
        _ = try! User(uuid: uuid, password: password)
            .save(on: connection)
            .wait()
        let data = "\(uuid):\(password)".data(using: .utf8)!.base64EncodedData()
        let base64 = String(data:data, encoding: .utf8)!
        var headers = HTTPHeaders()
        headers.add(name: "authorization", value: "Basic \(base64)")
        let uri = "http://localhost:8080/users"
        let response = try! app.client().get(uri, headers: headers, beforeSend: { _ in}).wait()

        XCTAssert(response.http.status == .ok)
    }
}

import App
import Vapor
import XCTest
import FluentMySQL
@testable import App

class BaseTestCase: XCTestCase {
    var app: Application!
    var connection: MySQLConnection!

    override func setUp() {
        app = Application.startTestApp()
        connection = try! app.newConnection(to: .mysql).wait()
    }

    override func tearDown() {
        Application.stopTestApp(app)
    }


}

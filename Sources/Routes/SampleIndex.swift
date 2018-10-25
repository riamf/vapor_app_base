import Foundation
import Leaf
import Vapor

class SampleIndex: RouteCollection {
    func boot(router: Router) throws {
        router.get("", use: indexHandler)
    }

    func indexHandler(request: Request) throws -> Future<View> {
        return try request.view().render("index")
    }
}

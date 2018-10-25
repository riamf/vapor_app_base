import Authentication
import Foundation
import Vapor
import Crypto

class BasicAuthRouter: RouteCollection {

    func boot(router: Router) throws {
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let protected = router.grouped(basicAuthMiddleware,
                                       guardAuthMiddleware)

        protected.get("users") { (request) -> Future<[User]> in
            return User.query(on: request).all()
        }
    }
}

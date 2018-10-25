import Vapor
import Foundation
import FluentMySQL
import Crypto

struct AdminUser: Migration {

    typealias Database = MySQLDatabase

    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        guard let password = Environment.get("MULTIPASS"),
            let user = try? User(uuid: UUID().uuidString,
                                 password: password) else {
            fatalError("UNABLE TO HASH PASSWORD 😱")
        }

        return user.save(on: conn).transform(to: ())
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}

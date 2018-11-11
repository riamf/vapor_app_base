import Vapor
import FluentMySQL

struct AdminUser: Migration {

    typealias Database = MySQLDatabase

    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        guard let password = Environment.get("MULTIPASS"),
            let uuid = Environment.get("MULTIPASS_UUID"),
            let user = try? User(uuid: uuid,
                                 password:  password) else {
            fatalError("UNABLE TO ADD ADMIN USER 😱")
        }

        return user.save(on: conn).transform(to: ())
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}

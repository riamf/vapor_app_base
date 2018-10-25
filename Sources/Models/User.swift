import Vapor
import FluentMySQL
import Crypto
import Authentication

final class User {

    var password: String
    var id: UUID?
    var uuid: String

    init(id: UUID? = nil, uuid: String, password: String) throws {
        self.id = id
        self.uuid = uuid
        self.password = try BCrypt.hash(password)
    }
}

extension User: MySQLUUIDModel {}
extension User: Codable {}
extension User: Model {}
extension User: Content {}
extension User: Parameter {}

extension User: BasicAuthenticatable {
    static var usernameKey: UsernameKey {
        return \User.uuid
    }

    static var passwordKey: PasswordKey {
        return \User.password
    }
}

extension User: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { (builder) in
            try addProperties(to: builder)
            builder.unique(on: \.id)
        })
    }
}

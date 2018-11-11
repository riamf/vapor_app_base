import Vapor
import FluentMySQL
import Crypto
import Authentication

final class User {

    struct Public: Codable, Content {

        let id: String
        let uuid: String
    }

    var id: Int?
    var password: String
    var uuid: String

    init(id: Int? = nil, uuid: String, password: String) throws {
        self.id = id
        self.uuid = uuid
        self.password = try BCrypt.hash(password)
    }

    func publicUser() -> Public {
        return Public(id: "\(id!)", uuid: uuid)
    }
}

extension User: MySQLModel {}
extension User: Parameter {}
extension User: Content {}

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

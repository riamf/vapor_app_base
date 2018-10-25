import Vapor
import FluentMySQL
import Crypto

final class User {

    var password: String
    var id: UUID?

    init(id: UUID? = nil, password: String) throws {
        self.id = id
        self.password = try BCrypt.hash(password)
    }
}

extension User: MySQLUUIDModel {}
extension User: Codable {}
extension User: Model {}
extension User: Content {}

extension User: Migration {
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { (builder) in
            try addProperties(to: builder)
            builder.unique(on: \.id)
        })
    }
}

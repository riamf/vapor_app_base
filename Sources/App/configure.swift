import FluentMySQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let hostname = Environment.get("MYSQL_HOST") ?? "localhost"
    let portString = Environment.get("MYSQL_PORT") ?? "3306"
    let username = Environment.get("MYSQL_USERNAME") ?? "root"
    let password = Environment.get("MYSQL_PASSWORD") ?? "root"
    let schema = Environment.get("MYSQL_DATABASE") ?? "db_name"
    let mysqlConfig = MySQLDatabaseConfig(hostname: hostname,
                                          port: Int(portString)!,
                                          username: username,
                                          password: password,
                                          database: schema)


    let mysql = MySQLDatabase(config: mysqlConfig)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}

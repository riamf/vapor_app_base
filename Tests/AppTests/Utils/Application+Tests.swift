import App
import Vapor
extension Application {

    static func startTestApp() -> Application {
        do {
            var app: Application!
            var env = try Environment.detect()
            var services = Services.default()
            var config = Config.default()

            env.commandInput.arguments = []

            try App.configure(&config, &env, &services)

            app = try Application(
                config: config,
                environment: env,
                services: services
            )

            try App.boot(app)
            try app.asyncRun().wait()
            return app
        } catch {
            fatalError("Unable to start App in tests")
        }
    }

    static func stopTestApp(_ app: Application) {
        try? app.runningServer?.close().wait()
    }
}

import Vapor
import SQLite

extension AirportSearcher: Service {}
extension Connection: Service {}

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    let db = try Connection(DirectoryConfig.detect().workDir + "/Resources/airports.sqlite3")
    services.register(db, as: Connection.self)
    
    let searcher = AirportSearcher(db)
    services.register(searcher, as: AirportSearcher.self)
}

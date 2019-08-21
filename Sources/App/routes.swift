import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("airportsearch") { req -> [String] in
        return ["foo", "bar"]
    }
    
    struct AirportRequest: Content {
        var term: String
    }
    
    router.get("search", String.parameter) { req -> String in
        let id = try req.parameters.next(String.self)
        return "requested id #\(id)"
    }

}

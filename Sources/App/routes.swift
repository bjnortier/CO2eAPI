import Vapor
import SQLite

fileprivate struct CO2eRequest: Content {
    var from: Int
    var to: Int
    var cabin: String
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("airports", String.parameter) { req -> [Airport] in
        let searcher = try req.make(AirportSearcher.self)
        let searchString = try req.parameters.next(String.self)
        let airports = searcher.query(searchString)
        return airports
    }
    
    struct CO2e: Content {
        let kgCO2e: Double
    }
    
    router.post("co2e") { req -> Future<CO2e> in
        let db = try req.make(Connection.self)
        
        return try req.content.decode(CO2eRequest.self).map(to: CO2e.self) { co2eRequest in
            guard ["economy", "business", "first"].contains(co2eRequest.cabin) else {
                throw Abort(.badRequest, reason: "Invalid cabin")
            }
            
            let a1 = try db.pluck(airports.filter(id == Int64(co2eRequest.from)))
            let a2 = try db.pluck(airports.filter(id == Int64(co2eRequest.to)))
            guard let fromRow = a1, let toRow = a2 else {
                throw Abort(.badRequest, reason: "Invalid Airport id(s)")
            }
            
            let from = Location(latitude: fromRow[latitude], longitude: fromRow[longitude])
            let to = Location(latitude: toRow[latitude], longitude: toRow[longitude])
            let cabin = Cabin.init(rawValue: co2eRequest.cabin)!
            
            return CO2e(kgCO2e: flightCO2e(from, to, cabin: cabin))
        }
    }

}

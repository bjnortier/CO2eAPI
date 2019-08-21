import Vapor
import SQLite

fileprivate struct CO2eRequest: Content {
    var from: Int
    var to: Int
    var cabin: String
}

fileprivate struct CO2eResponse: Content {
    let kgCO2e: Double
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("airports", String.parameter) { req -> [Airport] in
        let searcher = try req.make(AirportSearcher.self)
        let searchString = try req.parameters.next(String.self)
        let airports = searcher.query(searchString)
        return airports
    }
    
    router.post("co2e") { req -> Future<CO2eResponse> in
        let db = try req.make(Connection.self)
        
        return try req.content.decode(CO2eRequest.self).map(to: CO2eResponse.self) { co2eRequest in
            guard ["economy", "business", "first"].contains(co2eRequest.cabin) else {
                throw Abort(.badRequest, reason: "Invalid cabin")
            }
            
            let fromRowOpt = try db.pluck(airports.filter(id == Int64(co2eRequest.from)))
            let toRowOpt = try db.pluck(airports.filter(id == Int64(co2eRequest.to)))
            guard let fromRow = fromRowOpt, let toRow = toRowOpt else {
                throw Abort(.badRequest, reason: "Invalid Airport id(s)")
            }
            
            let from = Location(latitude: fromRow[latitude], longitude: fromRow[longitude])
            let to = Location(latitude: toRow[latitude], longitude: toRow[longitude])
            let cabin = Cabin.init(rawValue: co2eRequest.cabin)!
            
            return CO2eResponse(kgCO2e: flightCO2e(from, to, cabin: cabin))
        }
    }

}

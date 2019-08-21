import Vapor
import SQLite

fileprivate struct AirportSearchRequest: Content {
    var input: String
}

fileprivate struct CO2eRequest: Content {
    var from: Int
    var to: Int
    var cabin: String
}

fileprivate struct CO2eResponse: Content {
    let kgCO2e: Double
}

public func routes(_ router: Router) throws {
    router.get { req -> HTTPResponse in
        let res = HTTPResponse(
            status: .ok,
            headers: ["Content-Type": "text/html"],
            body: """
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>CO2e</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/png" href="/img/favicon-32x32.png" sizes="32x32" />
    <link rel="icon" type="image/png" href="/img/favicon-16x16.png" sizes="16x16" />
  </head>
  <body>
    <div id="root"></div>
    <script src="/index.bundle.js"> type="text/javascript"></script>
  </body>
</html>
""")
        return res
    }

    router.post("airportsearch") { req -> Future<[Airport]> in
        return try req.content.decode(AirportSearchRequest.self).map(to: [Airport].self) { airportSearchRequest in
            let searcher = try req.make(AirportSearcher.self)
            let airports = searcher.query(airportSearchRequest.input)
            return airports
        }
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

//
//  SearchAirports.swift
//  CO2eWeb
//
//  Created by Ben Nortier on 2019/08/13.
//  Copyright © 2019 Ben Nortier. All rights reserved.
//

import Foundation
import SQLite
import Vapor

struct Airport: Equatable, Hashable, Content {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

//let airports = Table("airports")
//let id = Expression<Int64>("id")
//let city = Expression<String>("city")
//let name = Expression<String>("name")
//let latitude = Expression<Double>("latitude")
//let longitude = Expression<Double>("longitude")
//let iata = Expression<String>("iata")

struct AirportTable: SQLTable, Codable {
    static let sqlTableIdentifierString = "airports"
    let id: Int
    let name: String
    let city: String
    let latitide: Double
    let longitude: Double
    let iata: String
}

class AirportSearcher {
    let db: SQLiteDatabase
//    let conn: SQLiteConnection
    
    init (_ db: SQLiteDatabase) {
        self.db = db
//        self.conn = try self.db.newConnection(on: {}).wait()
    }
    
    func query(on: Worker, query: String) -> [Airport] {
        let result = [Airport]()
        
//        router.post("airportsearch") { req -> Future<[Airport]> in
//            return try req.content.decode(AirportSearchRequest.self).map(to: [Airport].self) { airportSearchRequest in
//                let searcher = try req.make(AirportSearcher.self)
//                let airports = searcher.query(on: req, query: airportSearchRequest.input)
//                return airports
//            }
//        }
        
//        return self.db.newConnection(on: on).map(to: [Airport].self ) { connection in
//            print(connection)
//            return result
//        }
//        print(foo)
//        guard let conn = try? self.db.newConnection(on: req) else {
//            return result
//        }
//
//        if (query.count == 0) {
//            return result
//        }
//        if let rows = try? conn.query("SELECT sqlite_version();") {
//            print("!!", rows)
//        }
        
//        let wildcardQuery = "%\(query)%"
//        let airportRows = conn
//            .select()
//            .from(AirportTable.self)
//            .where(\AirportTable.name == wildcardQuery)
//            .limit(20)
//            .all(decoding: AirportTable.self)
//        print(airportRows)
        
//        return req.withPooledConnection(to: .sqlite) { conn in
//            return conn.select()
//                .column(function: "sqlite_version", as: "version")
//                .all(decoding: SQLiteVersion.self)
//            }.map { rows in
//                return rows[0].version
//        }
//        let rows = try? db.prepare(
//            airports
//                .filter(city.like(wildcardQuery) || name.like(wildcardQuery) || iata == query.uppercased())
//                .order(name)
//                .limit(20)
//        )
        
//        if let rows = rows {
//            for airportRow in rows {
//                result.append(
//                    Airport(
//                        id: Int(airportRow[id]),
//                        name: airportRow[name],
//                        latitude: airportRow[latitude],
//                        longitude: airportRow[longitude]
//                    )
//                )
//            }
//        }
        return result
    }
}

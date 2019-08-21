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

let airports = Table("airports")
let id = Expression<Int64>("id")
let city = Expression<String>("city")
let name = Expression<String>("name")
let latitude = Expression<Double>("latitude")
let longitude = Expression<Double>("longitude")
let iata = Expression<String>("iata")

class AirportSearcher {
    let db: Connection
    
    init (_ db: Connection) {
        self.db = db
    }
    
    func query(_ query: String) -> [Airport] {
        var result = [Airport]()
        if (query.count == 0) {
            return result
        }
        let wildcardQuery = "%\(query)%"
        let rows = try? db.prepare(
            airports
                .filter(city.like(wildcardQuery) || name.like(wildcardQuery) || iata == query.uppercased())
                .order(name)
                .limit(20)
        )
        
        if let rows = rows {
            for airportRow in rows {
                result.append(
                    Airport(
                        id: Int(airportRow[id]),
                        name: airportRow[name],
                        latitude: airportRow[latitude],
                        longitude: airportRow[longitude]
                    )
                )
            }
        }
        return result
    }
}

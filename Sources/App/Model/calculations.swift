//
//  calculations.swift
//  App
//
//  Created by Ben Nortier on 2019/08/21.
//

import Foundation

enum Cabin: String {
    case economy = "economy"
    case business = "business"
    case first = "first"
}

struct Location {
    let latitude: Double
    let longitude: Double
}

extension Double {
    func toRadians() -> Double {
        return self / 180.0 * .pi
    }
}

//
// https://www.movable-type.co.uk/scripts/latlong.html
//
func haversineDistance(_ from: Location, _ to: Location) -> Double {
    let R = 6371e3 // metres
    let phi1 = from.latitude.toRadians()
    let phi2 = to.latitude.toRadians()
    let deltaPhi = (to.latitude - from.latitude).toRadians()
    let deltaLambda = (to.longitude - from.longitude).toRadians()
    
    let a = sin(deltaPhi/2) * sin(deltaPhi/2) +
        cos(phi1) * cos(phi2) *
        sin(deltaLambda/2) * sin(deltaLambda/2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c / 1000
}

enum Haul {
    case short
    case long
}

func cw(_ cabin: Cabin, _ haul: Haul) -> Double {
    if (haul == .short) {
        switch(cabin) {
        case .economy: return 0.96
        case .business: return 1.26
        case .first: return 2.40
        }
    } else {
        switch(cabin) {
        case .economy: return 0.80
        case .business: return 1.54
        case .first: return 2.40
        }
    }
}

private let PLF = 0.82
private let EF = 3.15
private let P = 0.54
private let M = 2.0
private let AF = 0.00038
private let A = 11.68
private let DC = 95.0

private func shortHaul(x: Double, cabin: Cabin) -> Double {
    let a = 0.0000
    let b = 2.714
    let c = 1166.52
    
    let S = 153.51
    let CF = 1.0 - 0.93
    let CW = cw(cabin, .short)
    let result:Double = (a*x*x + b*x + c)/(S*PLF)*(1 - CF)*CW*(EF*M + P) + AF*x + A
    return result
}

private func longHaul(x: Double, cabin: Cabin) -> Double {
    let a = 0.0001
    let b = 7.104
    let c = 5044.93
    
    let S = 280.21
    let CF = 1.0 - 0.74
    let CW = cw(cabin, .long)
    let result:Double = (a*x*x + b*x + c)/(S*PLF)*(1 - CF)*CW*(EF*M + P) + AF*x + A
    return result
}

func flightCO2e(_ from: Location, _ to: Location, cabin: Cabin) -> Double {
    let x = haversineDistance(from, to) + DC
    if (x >= 2500) {
        return longHaul(x:x, cabin: cabin)
    } else if (x <= 1500) {
        return shortHaul(x:x, cabin: cabin)
    } else {
        let a = shortHaul(x:x, cabin: cabin)
        let b = longHaul(x:x, cabin: cabin)
        return a + (x - 1500.0)/1000.0*(b - a)
    }
    
}

//
//  PlanetsResponseDTO+Mapping.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

// MARK: - Data Transfer Object

struct PlanetsResponseDTO: Decodable {
    let count: Int
    let next, previous: String?
    let results: [PlanetDTO]
}

extension PlanetsResponseDTO {
    struct PlanetDTO: Decodable {
        let name, rotationPeriod, orbitalPeriod, diameter: String?
        let climate, gravity, terrain, surfaceWater: String?
        let population: String?
        // let residents, films: [String]
        let created, edited: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case rotationPeriod = "rotation_period"
            case orbitalPeriod = "orbital_period"
            case diameter, climate, gravity, terrain
            case surfaceWater = "surface_water"
            case population, created, edited, url
        }
    }
}
// MARK: - Mappings to Domain

extension PlanetsResponseDTO {
    func toDomain() -> PlanetsPage {
        return .init(count: count,
                     next: next,
                     previous: previous,
                     results: results.map { $0.toDomain() })
    }
}

extension PlanetsResponseDTO.PlanetDTO {
    func toDomain() -> Planet {
        return .init(name: name,
                     rotationPeriod: rotationPeriod,
                     orbitalPeriod: orbitalPeriod,
                     diameter: diameter,
                     climate: climate,
                     gravity: gravity,
                     terrain: terrain,
                     surfaceWater: surfaceWater,
                     population: population,
                     // residents: residents,
                     // films: films,
                     created: created,
                     edited: edited,
                     url: url
        )
    }
}


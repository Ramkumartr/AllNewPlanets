//
//  PlanetsResponseEntity+Mapping.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation
import CoreData

extension PlanetsResponseEntity {
    func toDTO() -> PlanetsResponseDTO {
        return .init(count: Int(count),
                     next: next,
                     previous: previous,
                     results: results?.allObjects.map { ($0 as! PlanetResponseEntity).toDTO() } ?? [])
    }
}

extension PlanetResponseEntity {
    func toDTO() -> PlanetsResponseDTO.PlanetDTO {
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
                     url: url)
    }
}


extension PlanetsRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> PlanetsRequestEntity {
        let entity: PlanetsRequestEntity = .init(context: context)
        entity.page = page
        return entity
    }
}

extension PlanetsResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> PlanetsResponseEntity {
        let entity: PlanetsResponseEntity = .init(context: context)
        entity.count = Int32(count)
        entity.next = next
        entity.previous = previous
        results.forEach {
            entity.addToResults($0.toEntity(in: context))
        }
        return entity
    }
}

extension PlanetsResponseDTO.PlanetDTO {
    func toEntity(in context: NSManagedObjectContext) -> PlanetResponseEntity {
        let entity: PlanetResponseEntity = .init(context: context)
        entity.name = name
        entity.rotationPeriod = rotationPeriod
        entity.orbitalPeriod = orbitalPeriod
        entity.diameter = diameter
        entity.climate = climate
        entity.gravity = gravity
        entity.terrain = terrain
        entity.surfaceWater = surfaceWater
        entity.population = population
        // entity.residents = residents
        // entity.films = films
        entity.created = created
        entity.edited = edited
        entity.url = url
        return entity
    }
}


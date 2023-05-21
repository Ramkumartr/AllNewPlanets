//
//  PlanetItemModel.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//
// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct PlanetItemModel: Equatable {
    let name: String
    let rotationPeriod, orbitalPeriod, diameter: String?
    let climate, gravity, terrain, surfaceWater: String?
    let population: String?
    let url: String?
}

extension PlanetItemModel {
    
    init(planet: Planet) {
        name = planet.name ?? ""
        rotationPeriod = planet.rotationPeriod
        orbitalPeriod = planet.orbitalPeriod
        diameter = planet.diameter
        climate = planet.climate
        gravity = planet.gravity
        terrain = planet.terrain
        surfaceWater = planet.surfaceWater
        population = planet.population
        url = planet.url
    }
}

extension PlanetItemModel: Identifiable {
    var id: String { name }
}

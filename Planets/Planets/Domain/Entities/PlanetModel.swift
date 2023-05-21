//
//  PlanetModel.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

// MARK: - PlanetsPage
struct PlanetsPage: Equatable {
    let count: Int
    let next, previous: String?
    let results: [Planet]
}

// MARK: - Planet
struct Planet: Equatable {
    let name, rotationPeriod, orbitalPeriod, diameter: String?
    let climate, gravity, terrain, surfaceWater: String?
    let population: String?
    // let residents, films: [String]  // For later updates
    let created, edited: String?
    let url: String?
}

//
//  PlanetsRepository.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol PlanetsRepository {
    
    func fetchPlanets(query: PlanetsQueryModel) async throws -> PlanetsPage
}

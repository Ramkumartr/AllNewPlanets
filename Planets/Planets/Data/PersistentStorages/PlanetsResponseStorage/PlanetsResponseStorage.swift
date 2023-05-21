//
//  PlanetsResponseStorage.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol PlanetsResponseStorage {
    func save(response: PlanetsResponseDTO, for requestDto: PlanetsRequestDTO)
    func getResponse(for request: PlanetsRequestDTO) async throws -> PlanetsResponseDTO?
}

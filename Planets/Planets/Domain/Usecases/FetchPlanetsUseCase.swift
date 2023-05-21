//
//  FetchPlanetsUseCase.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol FetchPlanetsUseCase {
    func execute(requestValue: FetchPlanetsUseCaseRequestValue) async throws -> PlanetsPage
}

final class DefaultFetchPlanetsUseCase: FetchPlanetsUseCase {
    
    @Injected(\.planetsRepository) private var planetsRepository: PlanetsRepository
    
    
    func execute(requestValue: FetchPlanetsUseCaseRequestValue) async throws -> PlanetsPage {
        
        return try await planetsRepository.fetchPlanets(query: requestValue.query)
    }
}

struct FetchPlanetsUseCaseRequestValue {
    let query: PlanetsQueryModel
}

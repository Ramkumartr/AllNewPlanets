//
//  DefaultPlanetsRepository.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultPlanetsRepository {
    
    @Injected(\.dataTransferService) private var dataTransferService: DataTransferService
    @Injected(\.planetsResponseStorage)  private var cache: PlanetsResponseStorage

}

extension DefaultPlanetsRepository: PlanetsRepository {
    
    public func fetchPlanets(query: PlanetsQueryModel) async throws -> PlanetsPage {
        let requestDTO = PlanetsRequestDTO(page: query.page)
        
        let cachedResult = try await cache.getResponse(for: requestDTO)
        
        if  let responseDTO = cachedResult {
            return responseDTO.toDomain()
        }
        
        let endpoint = APIEndpoints.getPlanetsList(with: requestDTO)
        do {
            let responseDTO = try await dataTransferService.request(with: endpoint)
            self.cache.save(response: responseDTO, for: requestDTO)
            return responseDTO.toDomain()
        } catch {
            throw error
        }

    }
}

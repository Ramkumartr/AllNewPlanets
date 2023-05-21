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
    
//    init(dataTransferService: DataTransferService, cache: PlanetsResponseStorage) {
//        self.dataTransferService = dataTransferService
//        self.cache = cache
//    }
}

extension DefaultPlanetsRepository: PlanetsRepository {
    
//    public func fetchPlanets(query: PlanetsQueryModel,
//                             cached: @escaping (PlanetsPage) -> Void,
//                             completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable? {
//        
//        let requestDTO = PlanetsRequestDTO(page: query.page)
//        let task = RepositoryTask()
//        
//        //            if case let .success(responseDTO?) = result {
//        //                cached(responseDTO.toDomain())
//        //            }
//        //  guard !task.isCancelled else { return }
//        
//        let endpoint = APIEndpoints.getPlanetsList(with: requestDTO)
//        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
//            switch result {
//            case .success(let responseDTO):
//                self.cache.save(response: responseDTO, for: requestDTO)
//                completion(.success(responseDTO.toDomain()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        return task
//    }
    
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
//        let result =  await dataTransferService.request(with: endpoint)
//        switch result {
//        case .success(let responseDTO):
//            self.cache.save(response: responseDTO, for: requestDTO)
//            return responseDTO.toDomain()
//        case .failure(let error):
//            throw error
//        }
    }
}

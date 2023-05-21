//
//  CoreDataPlanetsResponseStorage.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation
import CoreData

final class CoreDataPlanetsResponseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func fetchRequest(for requestDto: PlanetsRequestDTO) -> NSFetchRequest<PlanetsRequestEntity> {
        let request: NSFetchRequest = PlanetsRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@",
                                        #keyPath(PlanetsRequestEntity.page), requestDto.page)
        return request
    }
    
    private func deleteResponse(for requestDto: PlanetsRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
    private func getResponse(for request: PlanetsRequestDTO, completion: @escaping (Result<PlanetsResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: request)
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
}

extension CoreDataPlanetsResponseStorage: PlanetsResponseStorage {
    
    func getResponse(for request: PlanetsRequestDTO) async throws -> PlanetsResponseDTO? {
        
        return try await withCheckedThrowingContinuation { continuation in
            getResponse(for: request) { result in
                
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func save(response responseDto: PlanetsResponseDTO, for requestDto: PlanetsRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)
                
                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)
                
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

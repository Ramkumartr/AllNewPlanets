//
//  FetchPlanetsUseCaseTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 02/05/23.
//

import XCTest


class FetchPlanetsUseCaseTests: XCTestCase {
    
    static let planetsPage: PlanetsPage = {
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        let planet2 = Planet(name: "Tatooine2", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/2/")
        return PlanetsPage(count: 1, next: "https://swapi.dev/api/planets/?page=2", previous: nil, results: [planet1, planet2])}()
    
    
    enum PlanetsRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    struct PlanetsRepositoryMock: PlanetsRepository {
        
        var error: Error?
        var planetsPage:PlanetsPage?

        func fetchPlanets(query: PlanetsQueryModel) async throws -> PlanetsPage {
            if let error = error {
                throw error
            } else if let page = planetsPage {
                return page
            } else {
                throw PlanetsRepositorySuccessTestError.failedFetching
            }
            
        }
    }
    
    
    func testFetchPlanetsUseCase_whenSuccessfullyFetchesPlanets() async {
        // given
        let expectation = self.expectation(description: "Fetched Planets")
        let planetsRepository = PlanetsRepositoryMock(error: nil, planetsPage: FetchPlanetsUseCaseTests.planetsPage)
        
        let fetchPlanetUseCase = DefaultFetchPlanetsUseCase()
        InjectedValues[\.planetsRepository] = planetsRepository
        //When
        let requestValue = FetchPlanetsUseCaseRequestValue(query: PlanetsQueryModel(page: "1"))
        
        //then
        var planetsPage: PlanetsPage?
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        do {
      
            planetsPage = try await fetchPlanetUseCase.execute(requestValue: requestValue)
            XCTAssertNotNil(planetsPage)
            XCTAssertTrue(planetsPage!.results.contains(where: {$0 == planet1}))
        
        expectation.fulfill()
        } catch {
            XCTFail("Should return proper response")
            return
        }
       
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func testFetchPlanetsUseCase_whenFailedFetchingPlanets() async {
        // given
        let expectation = self.expectation(description: "Fetched Planets")
        let planetsRepository = PlanetsRepositoryMock(error: PlanetsRepositorySuccessTestError.failedFetching, planetsPage: nil)
        
        let fetchPlanetUseCase = DefaultFetchPlanetsUseCase()
        InjectedValues[\.planetsRepository] = planetsRepository
        //When
        let requestValue = FetchPlanetsUseCaseRequestValue(query: PlanetsQueryModel(page: "1"))
        
        
        var planetsPage: PlanetsPage?
        //then
        do {
            planetsPage = try await fetchPlanetUseCase.execute(requestValue: requestValue)
            XCTAssertNil(planetsPage)
          expectation.fulfill()
        } catch let error as PlanetsRepositorySuccessTestError {
            XCTAssertEqual(error, PlanetsRepositorySuccessTestError.failedFetching)
            expectation.fulfill()
        } catch {
            XCTFail("Should not happen")
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}

//
//  PlanetsViewModelTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 03/05/23.
//

import XCTest
import Combine

@testable import Planets

class PlanetsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    fileprivate enum FetchPlanetsUseCaseError: Error {
        case someError
    }
    
    let planetsPage: PlanetsPage = {
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        let planet2 = Planet(name: "Tatooine2", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/2/")
        return PlanetsPage(count: 1, next: "https://swapi.dev/api/planets/?page=2", previous: nil, results: [planet1, planet2])}()
    
    
    class FetchPlanetsUseCaseMock: FetchPlanetsUseCase {
        
        var expectation: XCTestExpectation?
        var error: Error?
        var planetsPage:PlanetsPage?
        
        func execute(requestValue: FetchPlanetsUseCaseRequestValue) async throws -> PlanetsPage {
            if let error = error {
                throw error
            } else if let planetsPage = planetsPage  {
                return planetsPage
            } else {
                throw FetchPlanetsUseCaseError.someError
            }
        }
        
    }
    
    func test_whenFetchPlanetsUseCaseRetrivesTwoPlanets_thenViewModelContainsOnlyTwoPlanets() {
        // given
        let fetchPlanetsUseCaseMock = FetchPlanetsUseCaseMock()
        let expectation = self.expectation(description: "contains only two planets")
        fetchPlanetsUseCaseMock.planetsPage = planetsPage
        
        InjectedValues[\.fetchPlanetsUseCase] = fetchPlanetsUseCaseMock
        let viewModel = PlanetsViewModel()
        
        viewModel.$planets
        // Remove the first (initial) value - we don't need it
            .dropFirst()
            .sink(receiveValue: { [weak self] in
                // Assert there are 2 new values
                XCTAssertEqual($0.count, 2)
                
                XCTAssertEqual($0.map { $0.name }, self?.planetsPage.results.map { $0.name })
                // Fulfill the expectation
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        //When
        viewModel.onViewDidLoad()
        
        //Then
        waitForExpectations(timeout: 5, handler: nil)
        //  addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenFetchPlanetsUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let fetchPlanetsUseCaseMock = FetchPlanetsUseCaseMock()
        let expectation = expectation(description: "contains error")
        
        InjectedValues[\.fetchPlanetsUseCase] = fetchPlanetsUseCaseMock
        let viewModel = PlanetsViewModel()
        
        
        viewModel.$error
        // Remove the first (initial) value - we don't need it
            .dropFirst()
            .sink(receiveValue: {
                // Assert there is error
                XCTAssertEqual($0, "Failed loading planets from network")
                XCTAssertEqual(viewModel.planets.count, 0)
                // Fulfill the expectation
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        //When
        viewModel.onViewDidLoad()
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
}

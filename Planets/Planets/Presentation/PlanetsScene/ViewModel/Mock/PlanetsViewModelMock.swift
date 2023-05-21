//
//  PlanetsViewModelMock.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 09/05/23.
//

import Foundation

final class PlanetsViewModelMock: PlanetsViewModelInterface {
    
    // MARK: - OUTPUT
    
    @Published var planets: [PlanetItemModel] = [PlanetItemModel]()
    @Published var loading: PlanetsViewModelLoading?
    @Published var error: String?
    @Published var screenTitle = NSLocalizedString("Planets", comment: "")
    var errorTitle: String = ""

    // MARK: - Init
    
    init() {
        let planet1 = Planet(name: "Tatooine", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/1/")
        
        let planet2 = Planet(name: "Tatooine2", rotationPeriod: "23", orbitalPeriod: "304", diameter: "10465", climate: "arid", gravity: "1 standard", terrain: "desert", surfaceWater: "1", population: "200000", created: "2014-12-09T13:50:49.641000Z", edited: "2014-12-20T20:58:18.411000Z", url: "https://swapi.dev/api/planets/2/")
        
        self.planets = [PlanetItemModel(planet: planet1),
                        PlanetItemModel(planet: planet2)]
    }
}

// MARK: - INPUT. View event methods

extension PlanetsViewModelMock {
    
    func onViewDidLoad() {
        
    }
}

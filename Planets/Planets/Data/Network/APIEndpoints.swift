//
//  APIEndpoints.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

struct APIEndpoints {
    
    static func getPlanetsList(with planetsRequestDTO: PlanetsRequestDTO) -> Endpoint<PlanetsResponseDTO> {
        
        return Endpoint(path: "planets",
                        method: .get,
                        queryParametersEncodable: planetsRequestDTO)
    }
    
}

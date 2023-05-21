//
//  DomainDI.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 21/05/23.
//

import Foundation

private struct FetchPlanetsUseCaseKey: InjectionKey {
    static var currentValue: FetchPlanetsUseCase = DefaultFetchPlanetsUseCase()
}

extension InjectedValues {
    
    var fetchPlanetsUseCase: FetchPlanetsUseCase {
        get { Self[FetchPlanetsUseCaseKey.self] }
        set { Self[FetchPlanetsUseCaseKey.self] = newValue }
    }
}

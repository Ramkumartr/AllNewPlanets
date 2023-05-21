//
//  PlanetsResponseStorageDI.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 21/05/23.
//

import Foundation

private struct PlanetsResponseStorageKey: InjectionKey {
    static var currentValue: PlanetsResponseStorage = CoreDataPlanetsResponseStorage()
}

extension InjectedValues {
    var planetsResponseStorage: PlanetsResponseStorage {
        get { Self[PlanetsResponseStorageKey.self] }
        set { Self[PlanetsResponseStorageKey.self] = newValue }
    }
}

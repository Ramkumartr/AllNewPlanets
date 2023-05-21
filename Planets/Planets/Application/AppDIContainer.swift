//
//  AppDIContainer.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    private(set) lazy var apiDataTransferService: DataTransferService = {
        return DefaultDataTransferService()
    }()
    
    // MARK: - DIContainers of scenes
    
    func makePlanetsSceneDIContainer() -> PlanetsSceneDIContainer {
        return PlanetsSceneDIContainer()
    }
}

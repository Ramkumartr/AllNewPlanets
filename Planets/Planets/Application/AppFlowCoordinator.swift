//
//  AppFlowCoordinator.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import UIKit

final class AppFlowCoordinator {
    
    private let router: Router
    private let appDIContainer: AppDIContainer
    
    init(router: Router, appDIContainer: AppDIContainer) {
        self.router = router
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let planetsSceneDIContainer = appDIContainer.makePlanetsSceneDIContainer()
        let flow = planetsSceneDIContainer.makePlanetsFlowCoordinator(router: router)
        flow.start()
    }
}

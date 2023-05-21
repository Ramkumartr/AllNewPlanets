//
//  PlanetsSceneDIContainer.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import UIKit
import SwiftUI

final class PlanetsSceneDIContainer {
    
    // MARK: - Use Cases
    func makeFetchPlanetsUseCase() -> FetchPlanetsUseCase {
        return DefaultFetchPlanetsUseCase()
    }
    
    
    // MARK: - Repositories
    func makePlanetsRepository() -> PlanetsRepository {
        return DefaultPlanetsRepository()
    }
    
    
    // MARK: - Planet List
    func makePlanetsViewController(actions: PlanetsViewModelActions) -> UIViewController {
        let view =  PlanetsListView(viewModel: makePlanetsViewModel(actions: actions))
        return UIHostingController(rootView: view)
    }
    
    func makePlanetsViewModel(actions: PlanetsViewModelActions) -> PlanetsViewModel {
        return PlanetsViewModel(actions: actions)
    }
    
    
    // MARK: - Flow Coordinators
    func makePlanetsFlowCoordinator(router: Router) -> PlanetsFlowCoordinator {
        return PlanetsFlowCoordinator(router: router,
                                      dependencies: self)
    }
}

extension PlanetsSceneDIContainer: PlanetsFlowCoordinatorDependencies {}

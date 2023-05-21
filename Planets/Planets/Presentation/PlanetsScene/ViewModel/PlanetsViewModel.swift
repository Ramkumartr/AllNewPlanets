//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

struct PlanetsViewModelActions {
    let showPlanetDetails: (Planet) -> Void
}

import Combine

enum PlanetsViewModelLoading {
    case requesting
}

protocol PlanetsViewModelInput {
    func onViewDidLoad()
}

protocol PlanetsViewModelOutput: ObservableObject {
    var planets: [PlanetItemModel] { get }
    var loading: PlanetsViewModelLoading? { get }
    var error: String? { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
}

protocol PlanetsViewModelInterface: PlanetsViewModelInput, PlanetsViewModelOutput {}

final class PlanetsViewModel: PlanetsViewModelInterface {
    
    @Injected(\.fetchPlanetsUseCase) private var fetchPlanetsUseCase: FetchPlanetsUseCase
    private let actions: PlanetsViewModelActions?
    
    let currentPage: Int = 1
    private var pages: [PlanetsPage] = []
    private var planetsLoadTask: Cancellable? { willSet { planetsLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    
    @Published var planets: [PlanetItemModel] = [PlanetItemModel]()
    @Published var loading: PlanetsViewModelLoading?
    @Published var error: String? = nil
    @Published var screenTitle = NSLocalizedString("Planets", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Init
    init(actions: PlanetsViewModelActions? = nil) {
        self.actions = actions
    }
    
    
    // MARK: - Private
    
    private func appendPage(_ planetsPage: PlanetsPage) async {
        pages = pages
            .filter { $0.next != planetsPage.next }
        + [planetsPage]
        
        await MainActor.run {
            self.loading = .none
            self.planets = self.pages.planets.map(PlanetItemModel.init).sorted(by: {$0.name < $1.name })
        }
        
    }
    
    private func load(planestQuery: PlanetsQueryModel, loading: PlanetsViewModelLoading) {
        self.loading = .requesting
        
        Task {
            
            do {
                let page = try await fetchPlanetsUseCase.execute(requestValue: .init(query: planestQuery))
                await self.appendPage(page)
            } catch {
                self.handle(error: error)
            }
        }
    }
    
    private func handle(error: Error) {
        self.error = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading planets from network", comment: "")
    }
}

// MARK: - INPUT. View event methods

extension PlanetsViewModel {
    
    func onViewDidLoad() {
        load(planestQuery: .init(page: String(currentPage)), loading: .requesting)
    }
}

// MARK: - Private

private extension Array where Element == PlanetsPage {
    var planets: [Planet] { flatMap { $0.results } }
}

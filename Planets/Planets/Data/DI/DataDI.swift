//
//  DataDI.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 21/05/23.
//

import Foundation


private struct PlanetsRepositoryKey: InjectionKey {
    static var currentValue: PlanetsRepository = DefaultPlanetsRepository()
}

private struct DataTransferServiceKey: InjectionKey {
    static var currentValue: DataTransferService = DefaultDataTransferService()
}

private struct NetworkServiceKey: InjectionKey {
    static var currentValue: NetworkService = DefaultNetworkService(config: ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration().apiBaseURL)!))
}

private struct DataTransferErrorResolverKey: InjectionKey {
    static var currentValue: DataTransferErrorResolver = DefaultDataTransferErrorResolver()
}

private struct DataTransferErrorLoggerKey: InjectionKey {
    static var currentValue: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
}

extension InjectedValues {
    
    
    var planetsRepository: PlanetsRepository {
        get { Self[PlanetsRepositoryKey.self] }
        set { Self[PlanetsRepositoryKey.self] = newValue }
    }
    
    var dataTransferService: DataTransferService {
        get { Self[DataTransferServiceKey.self] }
        set { Self[DataTransferServiceKey.self] = newValue }
    }
    
    var networkService: NetworkService {
        get { Self[NetworkServiceKey.self] }
        set { Self[NetworkServiceKey.self] = newValue }
    }
    
    var dataTransferErrorResolver: DataTransferErrorResolver {
        get { Self[DataTransferErrorResolverKey.self] }
        set { Self[DataTransferErrorResolverKey.self] = newValue }
    }
    
    var dataTransferErrorLogger: DataTransferErrorLogger {
        get { Self[DataTransferErrorLoggerKey.self] }
        set { Self[DataTransferErrorLoggerKey.self] = newValue }
    }
    
}

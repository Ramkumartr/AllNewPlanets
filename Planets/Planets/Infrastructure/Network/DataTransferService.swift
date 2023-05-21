//
//  DataTransferService.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol DataTransferService {
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T
    
    
    func request<E: ResponseRequestable>(with endpoint: E) async throws -> Void where E.Response == Void
}

public protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol DataTransferErrorLogger {
    func log(error: Error)
}

public final class DefaultDataTransferService {
    
    @Injected(\.networkService) private var networkService: NetworkService
    @Injected(\.dataTransferErrorResolver) private var errorResolver: DataTransferErrorResolver
    @Injected(\.dataTransferErrorLogger) private var errorLogger: DataTransferErrorLogger
    
}

extension DefaultDataTransferService: DataTransferService {
    
    public func request<T, E>(with endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : ResponseRequestable {
        
        do {
            let data = try await networkService.request(endpoint: endpoint)
            return try self.decode(data: data, decoder: endpoint.responseDecoder)
        } catch let error as NetworkError {
            self.errorLogger.log(error: error)
            let error = self.resolve(networkError: error)
            print(error)
            throw error
        } catch {
            self.errorLogger.log(error: error)
            print(error)
            throw error
        }
        
    }
    
    public func request<E>(with endpoint: E) async throws -> Void where E : ResponseRequestable, E.Response == Void {
        do {
            _ = try await networkService.request(endpoint: endpoint)
            return
        } catch let error as NetworkError {
            self.errorLogger.log(error: error)
            let error = self.resolve(networkError: error)
            throw error
        } catch {
            self.errorLogger.log(error: error)
            throw error
        }
        
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) throws -> T {
        do {
            guard let data = data else { throw DataTransferError.noResponse }
            let result: T = try decoder.decode(data)
            return result
        } catch let error as DataTransferError {
            self.errorLogger.log(error: error)
            throw error
        } catch {
            self.errorLogger.log(error: error)
            throw DataTransferError.parsing(error)
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        print(resolvedError)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Logger
public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public init() { }
    
    public func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver
public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

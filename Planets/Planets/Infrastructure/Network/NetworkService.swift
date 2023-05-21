//
//  NetworkService.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case noResponse
    case unauthorized
    //  case noData
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

public protocol NetworkService {
    
    func request(endpoint: Requestable) async throws -> Data?
}

public protocol NetworkSessionManager {
    
    typealias Response = (Data?, URLResponse?)
    
    func request(_ request: URLRequest) async throws -> Response
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
    
    private func request(request: URLRequest) async throws -> Data? {
        
        logger.log(request: request)
        
        do {
            let (data, response) = try await sessionManager.request(request)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            //            guard let data = data  else {
            //                throw NetworkError.noData
            //            }
            
            switch response.statusCode {
            case 200...299:
                return data
            case 401:
                throw NetworkError.unauthorized
            default:
                print("default error with response.statusCode \(response.statusCode)")
                throw NetworkError.error(statusCode: response.statusCode, data: data)
            }
        } catch let error as NetworkError {
            self.logger.log(error: error)
            throw error
        } catch {
            print("catch error \(error)")
            let error = self.resolve(error: error)
            self.logger.log(error: error)
            print(error)
            throw error
        }
        
    }
}

extension DefaultNetworkService: NetworkService {
    
    public func request(endpoint: Requestable) async throws -> Data? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            
            return try await request(request: urlRequest)
        } catch let error as NetworkError {
            print(error)
            throw error
        }
        catch {
            throw NetworkError.urlGeneration
        }
    }
}

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be incjected into NetworkService instead of default one.

public class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {}
    
    public func request(_ request: URLRequest) async throws -> Response {
        
        return try await URLSession.shared.data(for: request, delegate: nil)
    }
    
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }
    
    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
#if DEBUG
    print(string)
#endif
}

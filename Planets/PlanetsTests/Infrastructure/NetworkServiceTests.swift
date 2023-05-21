//
//  NetworkServiceTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 03/05/23.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock: Requestable {
        var path: String
        var isFullPath: Bool = false
        var method: HTTPMethodType
        var headerParameters: [String: String] = [:]
        var queryParametersEncodable: Encodable?
        var queryParameters: [String: Any] = [:]
        var bodyParametersEncodable: Encodable?
        var bodyParameters: [String: Any] = [:]
        var bodyEncoding: BodyEncoding = .stringEncodingAscii
        
        init(path: String, method: HTTPMethodType) {
            self.path = path
            self.method = method
        }
    }
    
    class NetworkErrorLoggerMock: NetworkErrorLogger {
        var loggedErrors: [Error] = []
        func log(request: URLRequest) { }
        func log(responseData data: Data?, response: URLResponse?) { }
        func log(error: Error) { loggedErrors.append(error) }
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let response =  HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: response,
                                                                                  data: expectedResponseData,
                                                                                  error: nil))
        
        //when
        do {
            let responseData = try await sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            
            XCTAssertEqual(responseData, expectedResponseData)
            expectation.fulfill()
        } catch {
            XCTFail("Should return proper response")
            return
        }
        //then
        wait(for: [expectation], timeout:0.1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: cancelledError as Error))
        
        //when
        do {
            let responseData = try await sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            XCTAssertNil(responseData)
            XCTFail("Should not happen")
            expectation.fulfill()
        } catch let error {
            guard case NetworkError.cancelled = error else {
                XCTFail("NetworkError.cancelled not found")
                return
            }
            
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                  data: nil,
                                                                                                  error: nil))
        
        //when
        do {
            let responseData = try await sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            XCTAssertNil(responseData)
            XCTFail("Should not happen")
            expectation.fulfill()
        } catch let error {
            if case NetworkError.error(let statusCode, _) = error {
                XCTAssertEqual(statusCode, 500)
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout:0.1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: error as Error))
        
        
        //when
        do {
            let responseData = try await sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            XCTAssertNil(responseData)
            XCTFail("Should not happen")
            expectation.fulfill()
        }  catch let error {
            guard case NetworkError.notConnected = error else {
                XCTFail("NetworkError.notConnected not found")
                return
            }
            
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        //when
        let sut = NetworkError.notConnected
        //then
        XCTAssertFalse(sut.hasStatusCode(200))
    }
    
    func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode_() {
        //when
        let sut = NetworkError.error(statusCode: 400, data: nil)
        //then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldLogThisError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkErrorLogger = NetworkErrorLoggerMock()
        let sut = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                                  data: nil,
                                                                                                  error: error as Error),
                                        logger: networkErrorLogger)
        
        //when
        do {
            let responseData = try await sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            XCTAssertNil(responseData)
            XCTFail("Should not happen")
            expectation.fulfill()
        } catch let error {
            guard case NetworkError.notConnected = error else {
                XCTFail("NetworkError.notConnected not found")
                return
            }
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(networkErrorLogger.loggedErrors.contains {
            guard case NetworkError.notConnected = $0 else { return false }
            return true
        })
    }
}

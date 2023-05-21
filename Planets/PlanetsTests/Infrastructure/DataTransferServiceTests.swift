//
//  DataTransferServiceTests.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 03/05/23.
//

import XCTest

private struct MockModel: Decodable {
    let name: String
}

class DataTransferServiceTests: XCTestCase {
    
    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() async throws {
        //given
        let config = NetworkConfigurableMock()
        
        let response =  HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        
        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: responseData,
                                                                                                             error: nil))
        
        
        
        let sut = DefaultDataTransferService()
        InjectedValues[\.networkService] = networkService
        
        //when
        let result = try await sut.request(with:  Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
        XCTAssertEqual(result.name, "Hello")
        
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should not decode mock object")
        
        let response =  HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let responseData = #"{"age": 20}"#.data(using: .utf8)
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: responseData,
                                                                                                             error: nil))
        
        let sut = DefaultDataTransferService()
        InjectedValues[\.networkService] = networkService
        
        //when
        do {
            _ = try await sut.request(with:  Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
            // XCTAssertNil(result)
            XCTFail("Should not happen")
        } catch {
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenBadRequestReceived_shouldRethrowNetworkError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw network error")
        
        let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: responseData,
                                                                                                             error: nil))
        
        
        
        let sut = DefaultDataTransferService()
        InjectedValues[\.networkService] = networkService
        
        //when
        do {
            _ = try await sut.request(with:  Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
            // XCTAssertNil(result)
            XCTFail("Should not happen")
        } catch let error as DataTransferError {
            print(error)
            if case DataTransferError.networkFailure(NetworkError.error(statusCode: 500, _)) = error {
                expectation.fulfill()
            } else {
                XCTFail("Wrong error")
            }
        } catch {
            XCTFail("Wrong error")
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenNoDataReceived_shouldThrowNoDataError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw no data error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = DefaultNetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                                             data: nil,
                                                                                                             error: nil))
        
        
        
        let sut = DefaultDataTransferService()
        InjectedValues[\.networkService] = networkService
        
        //when
        do {
            _ = try await sut.request(with:  Endpoint<MockModel>(path: "http://mock.endpoint.com", method: .get))
            // XCTAssertNil(result)
            XCTFail("Should not happen")
        } catch let error {
            if case DataTransferError.noResponse = error {
                expectation.fulfill()
            } else {
                XCTFail("Wrong error")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}

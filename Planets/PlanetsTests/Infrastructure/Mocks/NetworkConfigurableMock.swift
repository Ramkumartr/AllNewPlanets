//
//  NetworkConfigurableMock.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 01/05/23.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}

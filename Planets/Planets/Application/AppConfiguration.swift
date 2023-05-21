//
//  AppConfiguration.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

final class AppConfiguration {
    private(set)  lazy var apiBaseURL: String = {
        
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}

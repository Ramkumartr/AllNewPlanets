//
//  DataTransferError+ConnectionError.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}

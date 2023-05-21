//
//  Presentable.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation
import UIKit

protocol Presentable {
    
    func toPresent() -> UIViewController?
}

extension UIViewController : Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}

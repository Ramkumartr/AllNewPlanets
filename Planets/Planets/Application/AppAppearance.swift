//
//  AppAppearance.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation
import UIKit
import SwiftUI

final class AppAppearance {
    
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 37/255.0, green: 37/255.0, blue: 37.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}



extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Color {
    
    enum Text {
        static let charcoal: Color = .charcoal
        static let grey: Color = .grey
        static let white: Color = .white
        static let red: Color = .red
        
    }
    
    enum Background {
        static let charcoal: Color = Color.charcoal
        static let white: Color = Color.white
    }
    
    enum Brand {
        static let popsicle40: Color = Color.popsicle40
    }
    
    private static let charcoal: Color = Color(red: 22 / 255.0, green: 22 / 255.0, blue: 22 / 255.0)
    private static let grey: Color = Color(red: 81 / 255.0, green: 81 / 255.0, blue: 83 / 255.0)
    private static let popsicle40: Color = Color(red: 156 / 255.0, green: 44 / 255.0, blue: 243 / 255.0)
    private static let white: Color = Color(red: 1, green: 1, blue: 1)
}

extension UIFont {
    
    enum Heading {
        static var medium: UIFont =  UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let small: UIFont =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let extraSmall: UIFont = UIFont.systemFont(ofSize: 8, weight: .semibold)
    }
    
}

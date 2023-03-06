//
//  Crop.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//

import SwiftUI

// MARK: Crop Config
enum Crop: Equatable{
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    func name()->String{
        switch self {
        case .circle:
            return "Circle"
        case .rectangle:
            return "Rectangle"
        case .square:
            return "Square"
        case let .custom(cGSize):
            return "Custom \(Int(cGSize.width))X\(Int(cGSize.height))"
        }
    }
    
    func size()->CGSize{
        switch self {
        case .circle:
            return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .square:
            return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        case .custom(let cGSize):
            return cGSize
        }
    }
}

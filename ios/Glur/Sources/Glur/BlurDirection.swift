//
//  BlurDirection.swift
//  
//
//  Created by João Gabriel Pozzobon dos Santos on 09/02/24.
//

import SwiftUI

public enum BlurDirection {
    case down
    case up
    case right
    case left
    
    // Evaluated based on the layout direction
    case trailing
    case leading
    
    public enum Evaluated: Int {
        case down = 0
        case up = 1
        case right = 2
        case left = 3
    }
    
    public func evaluate(with direction: LayoutDirection) -> Evaluated {
        switch self {
        case .down:
            return .down
        case .up:
            return .up
        case .right:
            return .right
        case .left:
            return .left
        case .trailing:
            if direction == .leftToRight {
                return .right
            } else {
                return .left
            }
        case .leading:
            if direction == .leftToRight {
                return .left
            } else {
                return .right
            }
        }
    }
}


//
//  NSViewBorderExtension.swift
//  CrazyCooler
//
//  Created by Sunus on 01/03/2017.
//  Copyright © 2017 sunus. All rights reserved.
//

import Foundation
import Quartz

enum BorderEdge {
    case top
    case left
    case bottom
    case right
}

extension CALayer {
    
    func addBorder(edge: BorderEdge, color: NSColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case .bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case .left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case .right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

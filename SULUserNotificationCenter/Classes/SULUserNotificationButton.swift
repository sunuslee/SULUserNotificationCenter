//
//  SULUserNotificationButton.swift
//  CrazyCooler
//
//  Created by Sunus on 01/03/2017.
//  Copyright © 2017 sunus. All rights reserved.
//

import Cocoa

enum SUL_BorderEdge: Int {
    case top = 1
    case left = 2
    case bottom = 4
    case right = 8
    case unknown
}

extension CALayer {
    
    func SUL_addBorder(edge: SUL_BorderEdge, color: NSColor, thickness: CGFloat) {
        
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


open class SULUserNotificationButton: NSButton {
    static let buttonColor = NSColor(calibratedHue:0.5,
                                     saturation:0,
                                     brightness:0.94,
                                     alpha:1).cgColor
    static let buttonBorderColor = NSColor(calibratedHue:0,
                                           saturation:0,
                                           brightness:0.85,
                                           alpha:1)
    let actionButtonColor = NSColor(calibratedHue:0,
                                    saturation:0,
                                    brightness:0.44,
                                    alpha:1)
    
    open override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    public convenience init(_ frame:CGRect, title:String, target:AnyObject?, action:Selector?) {
        self.init()
        self.setSULButtonTitle(title: title)
        self.target = target
        self.action = action
        self.frame = frame
        self.setButtonType(.momentaryPushIn)
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.backgroundColor = SULUserNotificationButton.buttonColor
        self.layer?.SUL_addBorder(edge: .left, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
    }
    
    func buttonAttributes() -> [String:Any] {
        let pa = NSMutableParagraphStyle()
        pa.alignment = .center
        let attrs = [
            NSFontAttributeName: NSFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName:actionButtonColor,
            NSParagraphStyleAttributeName: pa
        ]
        return attrs
    }
    
    func setSULButtonTitle(title:String?) {
        guard let t = title else {
            return
        }
        self.attributedTitle = NSAttributedString(string: t, attributes:self.buttonAttributes())
        
    }
    
    func addBorder(borders:Int) {
        if (borders & SUL_BorderEdge.top.rawValue) != 0 {
            self.layer?.SUL_addBorder(edge: .top, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
        }
        
        if (borders & SUL_BorderEdge.bottom.rawValue) != 0 {
            self.layer?.SUL_addBorder(edge: .bottom, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
        }
        
        if (borders & SUL_BorderEdge.left.rawValue) != 0 {
            self.layer?.SUL_addBorder(edge: .left, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
        }
        
        if (borders & SUL_BorderEdge.right.rawValue) != 0 {
            self.layer?.SUL_addBorder(edge: .right, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
        }
        
    }
}

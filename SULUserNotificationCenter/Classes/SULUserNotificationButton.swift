//
//  SULUserNotificationButton.swift
//  CrazyCooler
//
//  Created by Sunus on 01/03/2017.
//  Copyright © 2017 sunus. All rights reserved.
//

import Cocoa

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
        let pa = NSMutableParagraphStyle()
        pa.alignment = .center
        self.attributedTitle = NSAttributedString(string: title, attributes:[
            NSFontAttributeName: NSFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName:actionButtonColor,
            NSParagraphStyleAttributeName: pa
            ])
        self.target = target
        self.action = action
        self.frame = frame
        self.setButtonType(.momentaryPushIn)
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.backgroundColor = SULUserNotificationButton.buttonColor
        self.layer?.addBorder(edge: .left, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
    }
    public func addBottomBorder() {
        self.layer?.addBorder(edge: .bottom, color: SULUserNotificationButton.buttonBorderColor, thickness: 1.0)
    }
    
}

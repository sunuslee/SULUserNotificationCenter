//
//  SULUserNotificationBackgroundView.swift
//  CrazyCooler
//
//  Created by Sunus on 01/03/2017.
//  Copyright © 2017 sunus. All rights reserved.
//

import Cocoa

class SULUserNotificationBackgroundView: NSView {
    var backgroundColor:NSColor?
    var cornerRadius:CGFloat?
    
    override func awakeFromNib() {
        cornerRadius = 5.0
        backgroundColor = NSColor(calibratedHue:0.5,
                                  saturation:0,
                                  brightness:0.94,
                                  alpha:1)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        self.wantsLayer = true
        self.layer?.cornerRadius = 5.0
        self.layer?.masksToBounds = true
        let bounds = self.bounds
        let bezierPath = NSBezierPath(roundedRect:bounds,
                                      xRadius:cornerRadius!,
                                      yRadius:cornerRadius!)
        backgroundColor?.set()
        bezierPath.fill()
    }
}

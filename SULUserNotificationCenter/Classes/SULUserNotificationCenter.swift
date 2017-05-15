//
//  SULUserNotificationCenter.swift
//  CrazyCooler
//
//  Created by Sunus on 28/02/2017.
//  Copyright © 2017 sunus. All rights reserved.
//

// SUL MEANS SUNUS LEE
// A Drop In Replacement for NSUserNotificationCenter
// With some handy operations

import Cocoa

@objc public protocol SULUserNotificationCenterDelegate {
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didDeliver notification:NSUserNotification)
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didActivate notification: NSUserNotification)
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool
    
    // additional handy functions
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didCancel notification: NSUserNotification)
}


open class SULUserNotificationCenter: NSObject {
    
    var currentNotification:NSUserNotification?
    var notifications:[SULUserNotificationWindowController] = []
    public var compareMode = false
   
    public var delegate:SULUserNotificationCenterDelegate?
    
    public static let `default`: SULUserNotificationCenter = {
        let instance = SULUserNotificationCenter()
        return instance
    }()
    
    /*
    open override func mouseEntered(with event: NSEvent) {
        self.addButton()
    }
    
    open override func mouseExited(with event: NSEvent) {
        self.removeButton()
    }
 */
    
    public func deliver(_ notification: NSUserNotification) {
        notification.deliveryDate = NSDate() as Date
        if let shouldPresent = self.delegate?.userNotificationCenter(_:shouldPresent:) , !shouldPresent(self, notification) {
            return
        }
        let notificationWindow = SULUserNotificationWindowController.init(notification,
                                                                          notificationCenter: self)
        notifications.insert(notificationWindow, at: 0)
        notificationWindow.displayNotification()
        
    }
    
    public func scheduleNotification(_ notification: NSUserNotification) {
        if let ddate = notification.deliveryDate, NSDate().compare(ddate) == .orderedAscending {
            self.perform(#selector(deliver(_:)),
                         with: notification,
                         afterDelay: ddate.timeIntervalSinceNow)
        } else {
            self.deliver(notification)
        }
    }
}

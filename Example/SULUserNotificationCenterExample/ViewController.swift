//
//  ViewController.swift
//  SULUserNotificationCenterExample
//
//  Created by Sunus on 10/05/2017.
//  Copyright © 2017 com.sunus. All rights reserved.
//

import Cocoa
import SULUserNotificationCenter

class ViewController: NSViewController, NSUserNotificationCenterDelegate, SULUserNotificationCenterDelegate {
    
    let SULcenter = SULUserNotificationCenter.default
    let NScenter = NSUserNotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NScenter.delegate = self
        SULcenter.delegate = self
        
        let notification = NSUserNotification.init()
        notification.title = "SUL_Notification Title"
        notification.subtitle = "SUL subtitle"
        notification.informativeText = "SULUserNotification is a dropin replacement for NSUserNotification"
        notification.actionButtonTitle = "OK"
        notification.otherButtonTitle = "Close"
        notification.contentImage = NSImage.init(named: "right-icon")
        notification.leftImage = NSImage.init(named: "left-icon")
        notification.deliveryDate = NSDate.init(timeIntervalSinceNow: 20) as Date
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Response Placeholder"
        notification.replyButtonTitle = "SUL_REPLY"
        print("\(NSDate.init(timeIntervalSinceNow: 0)) ->  \(notification.deliveryDate!)")
        SULcenter.compareMode = true
        NScenter.removeAllDeliveredNotifications()
        NScenter.deliver(notification)
    }
    
    @IBAction func sendNotification(_ sender: Any) {
        let notification = NSUserNotification.init()
        notification.title = "SUL_Notification Title"
        notification.subtitle = "SUL subtitle"
        notification.informativeText = "SULUserNotification is a dropin replacement for NSUserNotification"
        notification.actionButtonTitle = "REPLY"
        notification.otherButtonTitle = "Close"
        notification.contentImage = NSImage.init(named: "right-icon")
        notification.leftImage = NSImage.init(named: "left-icon")
        notification.deliveryDate = NSDate.init(timeIntervalSinceNow: 20) as Date
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Response Placeholder"
        notification.replyButtonTitle = "SUL_REPLY"
        NScenter.deliver(notification)
        SULcenter.deliver(notification)
    }
    
}

extension ViewController{
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        print("NSUserNotification Did Active")
    }
    
    func userNotificationCenter(_ center: SULUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        return true
    }
    
    func userNotificationCenter(_ center: SULUserNotificationCenter, didActivate notification: NSUserNotification) {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
    }
}

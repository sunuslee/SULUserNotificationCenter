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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let SULcenter = SULUserNotificationCenter.default
        let NScenter = NSUserNotificationCenter.default
        NScenter.delegate = self
        SULcenter.delegate = self
        
        let notification = NSUserNotification.init()
        notification.title = "NSNotification Title"
        notification.subtitle = "asdasdasd"
        notification.informativeText = "NSNotification informativeText A very long text to testing something weird A very long text to testing something weird"
        notification.actionButtonTitle = "Action Title"
        notification.otherButtonTitle = "Other Title"
        notification.contentImage = NSImage.init(named: "icon-wb")
        //notification.setLeftContentImage(NSImage.init(named: "icon-wb")!)
        notification.leftImage = NSImage.init(named: "icon-wb")
        
        notification.deliveryDate = NSDate.init(timeIntervalSinceNow: 20) as Date
        print("\(NSDate.init(timeIntervalSinceNow: 0)) ->  \(notification.deliveryDate!)")
        //SULcenter.deliver(notification)
        SULcenter.scheduleNotification(notification)
        //NScenter.deliver(notification)
        NScenter.scheduleNotification(notification)
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

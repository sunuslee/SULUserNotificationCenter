//
//  ViewController.swift
//  SULUserNotificationCenterExample
//
//  Created by Sunus on 10/05/2017.
//  Copyright © 2017 com.sunus. All rights reserved.
//

import Cocoa
import SULUserNotificationCenter

class ViewController: NSViewController, NSUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let SULcenter = SULUserNotificationCenter.sharedInstance
        let NScenter = NSUserNotificationCenter.default
        NScenter.delegate = self
        let notification = NSUserNotification.init()
        notification.title = "NSNotification Title"
        notification.informativeText = "NSNotification informativeText A very long text to testing something weird A very long text to testing something weird"
        notification.actionButtonTitle = "Action Title"
        notification.otherButtonTitle = "Other Title"
        notification.contentImage = NSImage.init(named: "icon-wb")
        SULcenter.deliver(notification)
        NScenter.deliver(notification)
    }
}

extension ViewController{
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }
}

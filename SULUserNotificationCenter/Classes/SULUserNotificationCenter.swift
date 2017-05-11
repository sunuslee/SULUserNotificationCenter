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



open class SULUserNotificationCenter: NSObject {
    
    var currentNotification:NSUserNotification?
    var notifications:[SULUserNotificationWindowController] = []
   
    public static let sharedInstance: SULUserNotificationCenter = {
        let instance = SULUserNotificationCenter()
        // setup code
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
        /*
        currentNotification = notification
        self.post(title: notification.title,
                  subtitle: notification.subtitle,
                  informativeText: notification.informativeText,
                  actionButtonTitle: notification.actionButtonTitle,
                  otherButtonTitle: notification.otherButtonTitle,
                  contentImage: notification.contentImage,
                  identifier: notification.identifier,
                  response: notification.response,
                  responsePlaceholder: notification.responsePlaceholder)
 */
        let notificationWindow = SULUserNotificationWindowController.init(notification,
                                                                          notificationCenter: self)
        notifications.append(notificationWindow)
        
        notificationWindow.displayNotification()
        
    }
    
    open func post(title:String?,
                   subtitle:String?,
                   informativeText:String?,
                   actionButtonTitle:String?,
                   otherButtonTitle:String?,
                   contentImage:NSImage?,
                   identifier:String?,
                   response: NSAttributedString?,
                   responsePlaceholder:String?) {
        
        /* TODO
        guard let w = self.window,
              let mainScreenFrame = NSScreen.main()?.frame
        else { return  }
        
        NSApplication.shared().activate(ignoringOtherApps: true)
        w.makeKeyAndOrderFront(nil)
        w.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        
        //log.warning("try to show window level : \(w.level)")
        
        if title != nil {
            self.title.stringValue = title!
        }
        
        if informativeText != nil {
            self.informativeText.stringValue = informativeText!
        }
        
        if contentImage != nil {
            leftContentImageView.image = contentImage
        } else {
            let appPath = Bundle.main.bundlePath
            leftContentImageView.image = NSWorkspace.shared().icon(forFile: appPath)
        }
        
        let startFrame = NSMakeRect(mainScreenFrame.size.width + mainScreenFrame.origin.x,
                                    notificationY,
                                    0,
                                    w.frame.size.height)
        w.setFrame(NSMakeRect(mainScreenFrame.size.width, notificationY, 0, w.frame.size.height),
                   display: true)
        
        let midFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth + mainScreenFrame.origin.x,
                                  notificationY,
                                  344,
                                  w.frame.size.height)

        
        let endFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth - 20 + mainScreenFrame.origin.x - 350,
                                  notificationY,
                                  344,
                                  w.frame.size.height)
        
        let animationEndFrame:[String:Any] = [NSViewAnimationTargetKey: w,
                                              NSViewAnimationStartFrameKey: midFrame,
                                              NSViewAnimationEndFrameKey: endFrame]
        
        let animation2 = NSViewAnimation(viewAnimations:[animationEndFrame])
        animation2.animationBlockingMode = NSAnimationBlockingMode.nonblocking
        animation2.duration = 0.15
        
        let animationStartFrame:[String:Any] = [NSViewAnimationTargetKey: w,
                                                NSViewAnimationStartFrameKey: startFrame,
                                                NSViewAnimationEndFrameKey: midFrame,
                                                // this keeps animation2 alive util animation1 finished
                                                // so animation1->animationStartFrame->animation2
                                                "retainAnimationObject": animation2]
        
        let animation1 = NSViewAnimation(viewAnimations:[animationStartFrame])
        animation1.animationBlockingMode = NSAnimationBlockingMode.nonblocking
        animation1.duration = 0.5
        
        animation2.start(when: animation1, reachesProgress: 1.0)
        animation1.start()
        
        if (actionButtonTitle != nil) {
            self.actionButtonTitle = actionButtonTitle
            self.hasActionButton = true
        }
        
        if (otherButtonTitle != nil) {
            self.otherButtonTitle = otherButtonTitle
            self.hasOtherButton = true
        }
        
        self.addButton()
        self.addContentImage()
        self.resizeTextField()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            //self.addButton()
            let trackingArea = NSTrackingArea(rect:(w.contentView?.bounds)!,
                                              options: [NSTrackingAreaOptions.mouseEnteredAndExited,
                                                        NSTrackingAreaOptions.activeAlways], owner:self, userInfo: nil)
            w.contentView?.addTrackingArea(trackingArea)
        }
 */
    }
    
    
    
    
    
}

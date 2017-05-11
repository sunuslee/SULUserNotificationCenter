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

@objc protocol SULUserNotificationCenterDelegate {
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didDeliver notification:NSUserNotification)
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didActivate notification: NSUserNotification)
    
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool
    
    // additional handy functions
    @objc optional func userNotificationCenter(_ center:SULUserNotificationCenter, didCancel notification: NSUserNotification)
}

open class SULUserNotificationCenter: NSWindowController {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var informativeText: NSTextField!
    @IBOutlet weak var leftContentImageView: NSImageView!
    
    var currentNotification:NSUserNotification?
    
    var delegate:SULUserNotificationCenterDelegate?
    
    let notificationWidth:CGFloat = 344.0
    let notificationHeight:CGFloat = 64.0
    let actionButtonWidth:CGFloat = 80.0
    let contentImageWidth:CGFloat = 48.0
    let contentImageHeight:CGFloat = 48.0
    let notificationY:CGFloat = 795.0
    
    var hasActionButton = true
    var hasOtherButton = false
    var hasReplyButton = false
    var actionButtonTitle:String?
    var otherButtonTitle:String?
    
    public static let sharedInstance: SULUserNotificationCenter = {
        let instance = SULUserNotificationCenter(windowNibName: "SULUserNotificationCenter")
        // setup code
        return instance
    }()
    
    override open func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        guard let w = self.window else {
            return
        }
        w.backgroundColor = NSColor.clear
    }
    
    /*
    open override func mouseEntered(with event: NSEvent) {
        self.addButton()
    }
    
    open override func mouseExited(with event: NSEvent) {
        self.removeButton()
    }
 */
    
    public func deliver(_ notification: NSUserNotification) {
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
    }
    
    func resizeTextField() {
        var spaceToReduce:CGFloat = 0
        if let _ = currentNotification?.actionButtonTitle,
            let _ = currentNotification?.otherButtonTitle {
            spaceToReduce += actionButtonWidth
        }
        
        if let _ = currentNotification?.contentImage {
            spaceToReduce += contentImageWidth
        }
        
        if spaceToReduce != 0 {
            var frame = informativeText.frame
            frame.size.width = frame.size.width - spaceToReduce
            informativeText.frame = frame
        }
    }
    
    
    func addButton()  {
        guard let window = self.window,
            let contentView = self.window?.contentView,
            let actionButtonTitle = currentNotification?.actionButtonTitle,
            let otherButtonTitle = currentNotification?.otherButtonTitle
        else { return }
        
        let buttonHeight = window.frame.size.height / 2.0
        let otherButtonFrame = NSMakeRect(notificationWidth - actionButtonWidth, buttonHeight, actionButtonWidth, buttonHeight);
        let actionButtonFrame = NSMakeRect(notificationWidth - actionButtonWidth, 0, actionButtonWidth, buttonHeight);
        let otherButton = SULUserNotificationButton.init(otherButtonFrame,
                                                          title: otherButtonTitle,
                                                          target: self,
                                                          action: #selector(clickOtherButton(_:)))
        
        let actionButton = SULUserNotificationButton.init(actionButtonFrame,
                                                          title: actionButtonTitle,
                                                          target: self,
                                                          action: #selector(clickActionButton(_:)))
        
        otherButton.addBottomBorder()
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 1.0
        contentView.animator().addSubview(otherButton)
        contentView.animator().addSubview(actionButton)
        NSAnimationContext.endGrouping()
    }
    
    func addContentImage() {
        guard let img = currentNotification?.contentImage,
            let contentView = self.window?.contentView
        else { return }
        
        img.size = NSMakeSize(contentImageWidth, contentImageHeight)
        let imgView = NSImageView()
        imgView.image = img
        var originX = notificationWidth - contentImageWidth - 8
        var originY = (notificationHeight - contentImageHeight) / 2.0
        if let _ = currentNotification?.actionButtonTitle,
            let _ = currentNotification?.otherButtonTitle {
            originX -= actionButtonWidth
        }
        
        
        
        contentView.addSubview(imgView)
    }
    
    
    func clickActionButton(_ sender:Any)  {
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        self.delegate?.userNotificationCenter?(self, didActivate: currentNotification!)
        self.close()
    }
    
    func clickOtherButton(_ sender:Any)  {
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        self.delegate?.userNotificationCenter?(self, didCancel: currentNotification!)
        self.close()
    }
    
    func removeButton() {
        guard let contentView = self.window?.contentView else {
            return
        }
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 1.0
        for v in contentView.subviews {
            if v is SULUserNotificationButton {
                v.animator().removeFromSuperview()
            }
        }
        NSAnimationContext.endGrouping()
    }
}

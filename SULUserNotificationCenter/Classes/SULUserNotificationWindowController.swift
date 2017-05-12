//
//  SULUserNotificationWindowController.swift
//  Pods
//
//  Created by Sunus on 11/05/2017.
//
//

import Cocoa

class SULUserNotificationWindowController: NSWindowController {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var informativeText: NSTextField!
    @IBOutlet weak var leftContentImageView: NSImageView!
    @IBOutlet weak var subtitle: NSTextField!
    
    
    var identifier:String?
    
    let notificationWidth:CGFloat = 344.0
    let notificationHeight:CGFloat = 64.0
    let actionButtonWidth:CGFloat = 80.0
    let contentImageWidth:CGFloat = 40.0
    let contentImageHeight:CGFloat = 40.0
    let notificationY:CGFloat = 795.0
    
    var currentNotification: NSUserNotification?
    var hasActionButton = true
    var hasOtherButton = false
    var hasReplyButton = false
    var actionButtonTitle:String?
    var otherButtonTitle:String?
    var contentImage:NSImage?
    var leftContentImage:NSImage?
    
    var notificationCenter:SULUserNotificationCenter?
    
    override open func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        guard let w = self.window else {
            return
        }
        w.backgroundColor = NSColor.clear
        
        title.stringValue =  (currentNotification?.title)!
        //subtitle.st notification.subtitle,
        informativeText.stringValue =  (currentNotification?.informativeText)!
        actionButtonTitle =  currentNotification?.actionButtonTitle
        otherButtonTitle = currentNotification?.otherButtonTitle
        contentImage = currentNotification?.contentImage
        identifier = currentNotification?.identifier
        /*
         response = notification.response
         responsePlaceholder = notification.responsePlaceholder
         */
        
        if let image = currentNotification?.leftImage {
            leftContentImage = image
        } else {
            let appPath = Bundle.main.bundlePath
            leftContentImage =  NSWorkspace.shared().icon(forFile: appPath)
        }
        
        leftContentImageView.image = leftContentImage
        
        addButton()
        addContentImage()
        resizeTextField()
        appendSubtitle()
    }
    
    public convenience init(_ notification:NSUserNotification,
                            notificationCenter center:SULUserNotificationCenter) {
        self.init(windowNibName: "SULUserNotificationWindowController")
        currentNotification = notification
        notificationCenter = center
    }
    
    public func displayNotification() {
        guard let w = self.window,
            let mainScreenFrame = NSScreen.main()?.frame
            else { return  }
        
        NSApplication.shared().activate(ignoringOtherApps: true)
        w.makeKeyAndOrderFront(nil)
        w.level = Int(CGWindowLevelForKey(.floatingWindow))
        
        
        let startFrame = NSMakeRect(mainScreenFrame.size.width + mainScreenFrame.origin.x,
                                    notificationY,
                                    0,
                                    w.frame.size.height)
        //w.setFrame(NSMakeRect(mainScreenFrame.size.width, notificationY, 0, w.frame.size.height),
        //           display: true)
        
        let midFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth + mainScreenFrame.origin.x,
                                  notificationY,
                                  notificationWidth,
                                  w.frame.size.height)
        
        
        let endFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth - 20 + mainScreenFrame.origin.x - 350,
                                  notificationY,
                                  notificationWidth,
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
    }
    
    func addButton()  {
        guard let window = self.window,
            let contentView = self.window?.contentView,
            let actionButtonTitle = actionButtonTitle, actionButtonTitle != "",
            let otherButtonTitle = otherButtonTitle, otherButtonTitle != ""
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
        guard let img = contentImage,
            let contentView = self.window?.contentView
        else { return }
        
        img.size = NSMakeSize(contentImageWidth, contentImageHeight)
        let imgView = NSImageView()
        imgView.image = img
        var originX = notificationWidth - contentImageWidth - 8
        let originY = (notificationHeight - contentImageHeight) / 2.0
        if let _ = currentNotification?.actionButtonTitle,
            let _ = currentNotification?.otherButtonTitle {
            originX -= actionButtonWidth
        }
        
        imgView.frame = NSMakeRect(originX,
                                   originY,
                                   contentImageWidth,
                                   contentImageHeight)
        
        contentView.addSubview(imgView)
    }
    
    func resizeTextField() {
        var spaceToReduce:CGFloat = 0
        
        if let s = currentNotification?.actionButtonTitle, !s.isEmpty {
            spaceToReduce += actionButtonWidth
        } else if let ss = currentNotification?.otherButtonTitle, !ss.isEmpty {
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
    
    func appendSubtitle() {
        if let st = currentNotification?.subtitle, !st.isEmpty {
            subtitle.stringValue = st
            subtitle.isHidden = false
            var frame = informativeText.frame
            frame.size.height = 16
            informativeText.frame = frame
        } else {
            subtitle.isHidden = true
        }
    }
    
    func clickActionButton(_ sender:Any)  {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        self.notificationCenter?.delegate?.userNotificationCenter?(notificationCenter!, didActivate: currentNotification!)
        self.close()
    }
    
    func clickOtherButton(_ sender:Any)  {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        self.notificationCenter?.delegate?.userNotificationCenter?(notificationCenter!, didCancel: currentNotification!)
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

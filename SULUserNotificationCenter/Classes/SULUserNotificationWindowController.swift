//
//  SULUserNotificationWindowController.swift
//  Pods
//
//  Created by Sunus on 11/05/2017.
//
//

import Cocoa

class SULUserNotificationWindow:NSWindow {
    override var canBecomeKey: Bool {
        get {
            return true
        }
    }
}

class SULUserNotificationWindowController: NSWindowController {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var informativeText: NSTextField!
    @IBOutlet weak var leftContentImageView: NSImageView!
    @IBOutlet weak var subtitle: NSTextField!
    @IBOutlet weak var replyTextField: NSTextField!
    
    
    var identifier:String?
    
    let notificationWidth:CGFloat = 344.0
    var notificationHeight:CGFloat = 64.0
    var actionButtonWidth:CGFloat = 80.0
    let contentImageWidth:CGFloat = 40.0
    let contentImageHeight:CGFloat = 40.0
    let notificationY:CGFloat = 795.0
    let defaultInformativeTextWidth:CGFloat = 274.0
    
    var currentNotification: NSUserNotification?
    var actionButton:SULUserNotificationButton?
    var otherButton:SULUserNotificationButton?
    var hasActionButton = true
    var hasOtherButton = false
    var hasReplyButton = false
    var actionButtonTitle:String?
    var otherButtonTitle:String?
    var contentImage:NSImage?
    var rightContentImageView:NSImageView?
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
        
        var windowFrame = w.frame
        windowFrame.size.height = notificationHeight
        w.setFrame(windowFrame, display: true)
        
        addButton()
        addContentImage()
        resizeTextField(isReplyMode: false)
        appendSubtitle()
        
    }
    
    public convenience init(_ notification:NSUserNotification,
                            notificationCenter center:SULUserNotificationCenter) {
        self.init(windowNibName: "SULUserNotificationWindowController")
        currentNotification = notification
        notificationCenter = center
        notificationHeight = 64
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
                                    notificationHeight)
        //w.setFrame(NSMakeRect(mainScreenFrame.size.width, notificationY, 0, w.frame.size.height),
        //           display: true)
        
        let midFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth + mainScreenFrame.origin.x,
                                  notificationY,
                                  notificationWidth,
                                  notificationHeight)
        
        
        let endFrame = NSMakeRect(mainScreenFrame.size.width - notificationWidth - 20 + mainScreenFrame.origin.x - 350,
                                  notificationY,
                                  notificationWidth,
                                  notificationHeight)
        
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
        otherButton = SULUserNotificationButton.init(otherButtonFrame,
                                                         title: otherButtonTitle,
                                                         target: self,
                                                         action: #selector(clickOtherButton(_:)))
        
        actionButton = SULUserNotificationButton.init(actionButtonFrame,
                                                          title: actionButtonTitle,
                                                          target: self,
                                                          action: #selector(clickActionButton(_:)))
        
        otherButton!.addBorder(borders: SUL_BorderEdge.bottom.rawValue)
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 1.0
        contentView.animator().addSubview(otherButton!)
        contentView.animator().addSubview(actionButton!)
        NSAnimationContext.endGrouping()
    }
    
    func addContentImage() {
        guard let img = contentImage,
            let contentView = self.window?.contentView
        else { return }
        
        img.size = NSMakeSize(contentImageWidth, contentImageHeight)
        rightContentImageView = NSImageView()
        rightContentImageView?.image = img
        var originX = notificationWidth - contentImageWidth - 8
        let originY = (notificationHeight - contentImageHeight) / 2.0
        if let _ = currentNotification?.actionButtonTitle,
            let _ = currentNotification?.otherButtonTitle {
            originX -= actionButtonWidth
        }
        
        rightContentImageView?.frame = NSMakeRect(originX,
                                                 originY,
                                                 contentImageWidth,
                                                 contentImageHeight)
        
        contentView.addSubview(rightContentImageView!)
    }
    
    func resizeTextField(isReplyMode:Bool) {
        var spaceToReduce:CGFloat = 0
        
        if !isReplyMode {
            if let s = currentNotification?.actionButtonTitle, !s.isEmpty {
                spaceToReduce += actionButtonWidth
            } else if let ss = currentNotification?.otherButtonTitle, !ss.isEmpty {
                spaceToReduce += actionButtonWidth
            }    
        } else {
            var frame = informativeText.frame
            frame.origin.y = (frame.origin.y - frame.size.height)
            frame.size.height = frame.size.height * 2.0
        }
        
        if let _ = currentNotification?.contentImage {
            spaceToReduce += contentImageWidth
        }
        
        if spaceToReduce != 0 {
            var frame = informativeText.frame
            frame.size.width = defaultInformativeTextWidth - spaceToReduce
            informativeText.frame = frame
            
        }
        
        if isReplyMode {
            if #available(OSX 10.11, *) {
                informativeText.maximumNumberOfLines = 2
            }
            var frame = informativeText.frame
            frame.origin.y -= frame.size.height
            frame.size.height *= 2.0
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
    
    func drawReplyView() {
        // subtitle is hidden when in reply mode
        // same in system's ui style
        subtitle.isHidden = true
        if let rightContentImageFrame = rightContentImageView?.frame {
            let x = notificationWidth - contentImageWidth - 12
            let y = notificationHeight - contentImageHeight - 12
            let frame = NSMakeRect(x,
                                   y,
                                   rightContentImageFrame.width,
                                   rightContentImageFrame.height)
            rightContentImageView?.frame = frame
        }
        if let actionButtonFrame = actionButton?.frame,
            let _ = otherButton?.frame {
            actionButtonWidth = notificationWidth / 2.0
            var f = actionButtonFrame
            f.size.width = actionButtonWidth
            f.origin = NSMakePoint(actionButtonWidth, 0)
            actionButton?.frame = f
            f.origin = NSZeroPoint
            otherButton?.frame = f
            otherButton!.addBorder(borders: SUL_BorderEdge.top.rawValue)
            actionButton?.addBorder(borders: SUL_BorderEdge.top.rawValue)
            actionButton?.setSULButtonTitle(title: currentNotification?.replyButtonTitle)
            
            actionButton?.action = #selector(clickReplyButton(_:))
        }
        
        resizeTextField(isReplyMode: true)
        
        if #available(OSX 10.10, *) {
            if let ph = currentNotification?.responsePlaceholder {
                self.replyTextField.placeholderString = ph
            }
        }
        
        return
    }
    
    func clickActionButton(_ sender:Any)  {
        #if DEBUG
            Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        
        if let w = self.window, (currentNotification?.hasReplyButton)! {
            replyTextField.focusRingType = .none
            replyTextField.wantsLayer = true
            replyTextField.layer?.cornerRadius = 5.0
            notificationHeight = 142
            var windowFrame = w.frame
            windowFrame.size.height = notificationHeight
            windowFrame.origin.y -= 76.0
            drawReplyView()
            w.setFrame(windowFrame, display: true, animate:true)
        } else {
            self.notificationCenter?.delegate?.userNotificationCenter?(notificationCenter!, didActivate: currentNotification!)
            self.close()
        }
    }
    
    
    func clickOtherButton(_ sender:Any)  {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        self.notificationCenter?.delegate?.userNotificationCenter?(notificationCenter!, didCancel: currentNotification!)
        self.close()
    }
    
    func clickReplyButton(_ sender:Any) {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        self.currentNotification?.SUL_response = replyTextField.attributedStringValue
        self.notificationCenter?.delegate?.userNotificationCenter?(notificationCenter!, didActivate: currentNotification!)
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

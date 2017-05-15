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

class SULUserNotificationWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var informativeText: NSTextField!
    @IBOutlet weak var leftContentImageView: NSImageView!
    @IBOutlet weak var subtitle: NSTextField!
    @IBOutlet weak var replyTextField: NSTextField!
    
    
    var identifier:String?
    
    let notificationRightSpacing:CGFloat = 20.0
    let notificationWidth:CGFloat = 344.0
    var notificationHeight:CGFloat = 64.0
    var actionButtonWidth:CGFloat = 80.0
    let contentImageWidth:CGFloat = 40.0
    let contentImageHeight:CGFloat = 40.0
    let notificationMaxY:CGFloat = 795.0
    var notificationY:CGFloat = 795.0
    var notificationX:CGFloat = 0
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
        w.delegate = self
        w.backgroundColor = NSColor.clear
        
        title.stringValue =  (currentNotification?.title)!
        informativeText.stringValue =  (currentNotification?.informativeText)!
        actionButtonTitle =  currentNotification?.actionButtonTitle
        otherButtonTitle = currentNotification?.otherButtonTitle
        contentImage = currentNotification?.contentImage
        identifier = currentNotification?.identifier
        
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
        if let mainScreenFrame = NSScreen.main()?.frame {
            notificationX = mainScreenFrame.origin.x + mainScreenFrame.size.width - notificationWidth - notificationRightSpacing
            if center.compareMode {
                notificationX -= 350
            }
        }
    }
    
    func moveNotificationUpToPreviousAnimation(offset:CGFloat) -> [String : Any] {
        return moveNotificationAnimation(offset: offset)
    }
    
    func moveNotificationDownByNewNotificationAnimation() -> [String : Any] {
        return moveNotificationAnimation(offset: -(64 + 10))
    }
    
    func moveNotificationDownByReplyAnimation() -> [String: Any ] {
        return moveNotificationAnimation(offset: -(76))
    }
    
    func moveNotificationAnimation(offset:CGFloat) -> [String:Any] {
        let startFrame = self.window!.frame
        var endFrame = startFrame
        notificationY += offset
        endFrame.origin.y = notificationY
        endFrame.origin.x = notificationX
        endFrame.size.width = notificationWidth
        let ani = [
            NSViewAnimationTargetKey:self.window!,
            NSViewAnimationStartFrameKey: startFrame,
            NSViewAnimationEndFrameKey: endFrame
        ] as [String : Any];
        return ani
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
        w.setFrame(startFrame, display: false)
        
        let midFrame = NSMakeRect(notificationX + notificationRightSpacing,
                                  notificationY,
                                  notificationWidth,
                                  notificationHeight)
        
        let endFrame = NSMakeRect(notificationX,
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
        
        var otherNotificationsAnimations:[[String:Any]] = []
        
        if let otherNotifications = self.notificationCenter?.notifications[1..<(self.notificationCenter?.notifications.endIndex)!] {
            let t = otherNotifications.map({
                $0.moveNotificationDownByNewNotificationAnimation()
            })
            otherNotificationsAnimations.append(contentsOf: t)
        }
    
        otherNotificationsAnimations.insert(animationStartFrame, at: 0)
        
        let animation1 = NSViewAnimation(viewAnimations:otherNotificationsAnimations)
        animation1.animationBlockingMode = .nonblocking
        animation1.duration = 0.50
        animation1.start()
        
        animation2.animationBlockingMode = .nonblocking
        animation2.duration = 0.15
        animation2.start(when: animation1, reachesProgress: 1.0)
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
            
            var otherNotificationsAnimations:[[String:Any]] = []
            
            if let selfIndex = notificationCenter?.notifications.index(of: self),
                let otherNotifications = self.notificationCenter?.notifications[selfIndex..<(self.notificationCenter?.notifications.endIndex)!] {
                let t = otherNotifications.map({
                    $0.moveNotificationDownByReplyAnimation()
                })
                otherNotificationsAnimations.append(contentsOf: t)
            }
            let animator = NSViewAnimation(viewAnimations:otherNotificationsAnimations)
            animator.duration = 0.65
            animator.start()
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
    
    func windowWillClose(_ notification: Notification) {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        if let selfIndex = notificationCenter?.notifications.index(of: self), selfIndex < (notificationCenter?.notifications.endIndex)!,
            let otherNotifications = self.notificationCenter?.notifications[(selfIndex+1)..<(notificationCenter?.notifications.endIndex)!],
            let first = otherNotifications.first {
            let offset = (notificationY + notificationHeight) - (first.notificationY + first.notificationHeight)
            let otherNotificationsAnimations = otherNotifications.map({
                $0.moveNotificationUpToPreviousAnimation(offset:offset)
            })
            let animator = NSViewAnimation(viewAnimations:otherNotificationsAnimations)
            animator.duration = 0.65
            animator.start()
        }
        if let selfIndex = notificationCenter?.notifications.index(of: self) {
            notificationCenter?.notifications.remove(at: selfIndex)
        }
    }
}

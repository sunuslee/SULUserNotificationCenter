# SULUserNotificationCenter
A Drop in replacement for NSUserNotification with a few handy tweaks, written in Swift 3.0!
See the example by ```pod try SULUserNotification```

# Install
pod "SULUserNotificationCenter"

# Getting Started

### deliver usernotification 

Just replace your ```NSUserNotificationCenter``` to ```SULUserNotificationCenter```
See below
```

// ********REPLACE this line
// let NScenter = NSUserNotificationCenter.default
// ********With this line
let SULcenter = SULUserNotificationCenter.default

let notification = NSUserNotification.init()
notification.title = "SUL_Notification Title"
notification.subtitle = "SUL subtitle"
notification.informativeText = "SULUserNotification is a dropin replacement for NSUserNotification"
notification.actionButtonTitle = "REPLY"
notification.otherButtonTitle = "Close"
notification.contentImage = NSImage.init(named: "right-icon")

// you can custom this leftImage.
notification.leftImage = NSImage.init(named: "left-icon")
notification.deliveryDate = NSDate.init(timeIntervalSinceNow: 20) as Date
notification.hasReplyButton = true
notification.responsePlaceholder = "Response Placeholder"
notification.replyButtonTitle = "SUL_REPLY"

// ***********REPLACE this line
//NScenter.deliver(notification)

// ***********With this line
SULcenter.deliver(notification)
```

### Delegates

Replace ```NSUserNotificationCenterDelegate``` With  ```SULUserNotificationCenterDelegate```


```
extension ViewController{

    // Replace the first two delegate methods
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true;
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        #if DEBUG
        Swift.print("Function: \(type(of:self)) \(#function), line: \(#line)")
        #endif
        print("NSUserNotification Did Active")
    }
    
    // With this two delegate methods
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
```

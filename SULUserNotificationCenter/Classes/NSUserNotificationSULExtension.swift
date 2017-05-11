//
//  File.swift
//  Pods
//
//  Created by Sunus on 11/05/2017.
//
//

import Foundation

private var leftImageKey: Void?

public extension NSUserNotification {
    var leftImage: NSImage? {
        get {
            return objc_getAssociatedObject(self, &leftImageKey) as? NSImage
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &leftImageKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

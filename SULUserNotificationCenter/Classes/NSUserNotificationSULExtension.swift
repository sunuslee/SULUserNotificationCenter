//
//  File.swift
//  Pods
//
//  Created by Sunus on 11/05/2017.
//
//

import Foundation

private var leftImageKey: Void?
private var responseKey: Void?
private var replyButtonTitleKey: Void?

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
    
    var replyButtonTitle: String? {
        get {
            return objc_getAssociatedObject(self, &replyButtonTitleKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &replyButtonTitleKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal(set) var SUL_response: NSAttributedString? {
        get {
            return objc_getAssociatedObject(self, &responseKey) as? NSAttributedString
        }
        set {
            objc_setAssociatedObject(self, &responseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

//
//  UserDefaults+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 06/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import Foundation

private let kAlreadyAskedForNotificationPermission = "alreadyAskedForNotificationPermission"
private let kNotificationsEnabled = "notificationsEnabled"
private let kNotificationsStartDate = "notificationsStartDate"
private let kNotificationsEndDate = "notificationsEndDate"

private let kAccessToken = "accessToken"
private let kCounselorEmail = "counselorEmail"

private let kCurrentWhenHubScheduleId = "currentWhenHubScheduleId"
private let kLastUploadTimestamp = "lastUploadTimestamp"

private let kDummyDatabaseContent = "dummyDatabaseContent"

extension UserDefaults
{
    // MARK: Notifications
    
    var alreadyAskedForNotificationPermission: Bool {
        set {
            self.set(newValue, forKey: kAlreadyAskedForNotificationPermission)
        }
        get {
            return self.bool(forKey: kAlreadyAskedForNotificationPermission)
        }
    }
        
    var notificationsEnabled: Bool {
        set {
            self.set(newValue, forKey: kNotificationsEnabled)
        }
        get {
            return self.bool(forKey: kNotificationsEnabled)
        }
    }
    
    var notificationsStartDate: Date? {
        set {
            self.set(newValue, forKey: kNotificationsStartDate)
        }
        get {
            return self.object(forKey: kNotificationsStartDate) as? Date
        }
    }
    
    var notificationsEndDate: Date? {
        set {
            self.set(newValue, forKey: kNotificationsEndDate)
        }
        get {
            return self.object(forKey: kNotificationsEndDate) as? Date
        }
    }
    
    // MARK: WhenHub
    
    var accessToken: String? {
        set {
            self.set(newValue, forKey: kAccessToken)
        }
        get {
            return self.string(forKey: kAccessToken)
        }
    }
    
    var currentWhenHubScheduleId: String? {
        set {
            self.set(newValue, forKey: kCurrentWhenHubScheduleId)
        }
        get {
            return self.string(forKey: kCurrentWhenHubScheduleId)
        }
    }
    
    var lastUploadTimestamp: Date? {
        set {
            self.set(newValue, forKey: kLastUploadTimestamp)
        }
        get {
            return self.object(forKey: kLastUploadTimestamp) as? Date
        }
    }
    
    // MARK: Other
    
    var counselorEmail: String? {
        set {
            self.set(newValue, forKey: kCounselorEmail)
        }
        get {
            return self.string(forKey: kCounselorEmail)
        }
    }
    
    var dummyDatabaseContent: Data? {
        set {
            self.set(newValue, forKey: kDummyDatabaseContent)
        }
        get {
            return self.object(forKey: kDummyDatabaseContent) as? Data
        }
    }
}

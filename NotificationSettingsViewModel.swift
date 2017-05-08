//
//  NotificationSettingsViewModel.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UserNotifications

protocol NotificationSettingsViewModelDelegate: class {
    func didSet(notificationsEnabled: Bool, with title: String?, and message: String?, in viewModel: NotificationSettingsViewModel)
}

class NotificationSettingsViewModel {
    
    weak var delegate: NotificationSettingsViewModelDelegate?
    
    private(set) var isOn: Bool
    var startDate: Date
    var endDate: Date
    
    init() {
        // Try to load previous settings or set defaults.
        let today = Date()
        self.startDate = UserDefaults.standard.notificationsStartDate ?? Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: today) ?? today
        self.endDate = UserDefaults.standard.notificationsEndDate ?? Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: today) ?? today
        self.isOn = UserDefaults.standard.notificationsEnabled
    }
    
    func set(isOn: Bool) {
        self.isOn = isOn
        if isOn {
            self.ensurePermissionGranted()
        }
        else {
            self.delegate?.didSet(notificationsEnabled: self.isOn, with: nil, and: nil, in: self)
        }
    }
    
    func ensurePermissionGranted() {
        print("ensurePermissionGranted")
        
        UNUserNotificationCenter.current().getNotificationSettings() { settings in
            switch settings.authorizationStatus
            {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [ .alert, .sound ]) { (granted, error) in
                    if !granted {
                        self.isOn = false
                    }
                    self.delegate?.didSet(notificationsEnabled: self.isOn, with: nil, and: nil, in: self)
                }
                
            case .denied:
                self.isOn = false
                let title = NSLocalizedString("Enable notifications", comment: "")
                let message = NSLocalizedString("Go to Settings and enable notifications for MyMood to receive reminders", comment: "")
                self.delegate?.didSet(notificationsEnabled: false, with: title, and: message, in: self)
                
            case .authorized:
                guard settings.alertSetting == .enabled else {
                    self.isOn = false
                    let title = NSLocalizedString("Alerts are disabled", comment: "")
                    let message = NSLocalizedString("Go to Settings and enable alerts for MyMood to receive reminders", comment: "")
                    self.delegate?.didSet(notificationsEnabled: false, with: title, and: message, in: self)
                    return
                }
                self.delegate?.didSet(notificationsEnabled: true, with: nil, and: nil, in: self)
            }
        }
    }
    
    /// Persist settings to UserDefaults and update scheduled notifications. Call this before leaving view controller or closing app.
    func save() {
        print("save")
        
        UserDefaults.standard.notificationsEnabled = self.isOn
        UserDefaults.standard.notificationsEndDate = self.endDate
        UserDefaults.standard.notificationsStartDate = self.startDate
        
        // Should only be `true` if we have the right permissions.
        if self.isOn {
//            self.scheduleNotifications()
        }
        else {
            
        }
    }
    
    // TODO: Enable this in later version.
    private func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Time to add a note", comment: "")
        content.body = NSLocalizedString("Add a note every hour to make the therapy most effective", comment: "")
        
        // Deliver the notification in five seconds.
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
}

//
//  AppDelegate.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    struct Notifications {
        static let willEnterForeground = Notification.Name("AppDelegate.willEnterForeground")
        static let didEnterBackground = Notification.Name("AppDelegate.didEnterBackground")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow()
        let viewController = DashboardViewController(viewModel: DashboardViewModel())
        self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(Notification(name: Notifications.willEnterForeground))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(Notification(name: Notifications.didEnterBackground))
        
        // TODO: Remove this dummy scheduling in later version.
        if UserDefaults.standard.notificationsEnabled {
            self.scheduleDummyNotification()
        }
    }
    
    private func scheduleDummyNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Time to journal", comment: "")
        content.body = NSLocalizedString("If you journal often the therapy will be more effective!", comment: "")
        
        // Deliver the notification in five seconds.
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    // MARK: - Core Data stack - NOT USED IN CURRENT VERSION

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyMood")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support - NOT USED IN CURRENT VERSION

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // Dismiss any modal.
            self.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            // Pop to root.
            guard let navigationController = self.window?.rootViewController as? UINavigationController else { return }
            navigationController.popToRootViewController(animated: false)
            
            // Present form.
            DispatchQueue.main.async {
                let viewController = EntryFormViewController(viewModel: EntryFormViewModel())
                navigationController.topViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

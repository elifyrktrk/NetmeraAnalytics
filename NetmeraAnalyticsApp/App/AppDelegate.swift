//
//  AppDelegate.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import UIKit
import CoreData
import NetmeraAnalytic
import NetmeraNotification
import NetmeraLocation
import NetmeraNotificationInbox
import NetmeraAdvertisingId
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Netmera.initialize()  
        Netmera.setLogLevel(.debug) // Options: .debug, .info, .error, .fault  
        // Use .debug mode to view detailed Netmera logs
        Netmera.requestPushNotificationAuthorization(for: [.alert, .badge, .sound])
        Netmera.requestLocationAuthorization()

        // Set the delegate for the notification center
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //
    }

    // Handle user interaction with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
    }
    
/*
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
   let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
   let token = tokenParts.joined()
   print("Device Token: \(token)")
 }

 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
   print("Failed to register: \(error)")
 }

 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
   print("SwiftDemo openUrl: \(url)")
   if let vc = UIApplication.topViewController() {
     vc.showAlert("Deeplink Detected", message: url.absoluteString, .alert, nil)
   }
   return true
 }

 func application(_ application: UIApplication,
                  continue userActivity: NSUserActivity,
                  restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
 {
   // Get URL components from the incoming user activity.
   guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
         let incomingURL = userActivity.webpageURL,
         let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
     return false
   }

   print(incomingURL)
   return true
 }

 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
   if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo,
                                                 options: [.prettyPrinted]) {
     let jsonStringData = NSString(data: jsonData as Data, encoding: NSUTF8StringEncoding)! as String
     print("didReceiveRemoteNotification \n \(jsonStringData)")

     let pushInfo = PushInfo(date: Date(), payload: jsonStringData)
     PushEventMonitor.shared.history.append(pushInfo)
   }
   completionHandler(.noData)
 }
}

extension AppDelegate: NetmeraPushDelegate {
 func shouldHandleWebViewPresentation(for pushObject: NetmeraBasePush) -> Bool {
   return UserDefaults.standard.bool(forKey: NotificationDelegateSetting.webViewHandling.rawValue)
 }

 func handleWebViewPresentation(for pushObject: NetmeraBasePush) {
   print("handleWebViewPresentation")
 }

 func shouldHandlePresentation(for pushObject: NetmeraBasePush) -> Bool {
   return UserDefaults.standard.bool(forKey: NotificationDelegateSetting.presentationHandling.rawValue)
 }

 func handlePresentation(for pushObject: NetmeraBasePush) {
   print("handlePresentation")
 }

 func shouldHandleOpenURL(_ url: URL, for pushObject: NetmeraBasePush) -> Bool {
   if url.host == "your_domain" {
     return true
   }
   return UserDefaults.standard.bool(forKey: NotificationDelegateSetting.deeplinkHandling.rawValue)
 }

 func handleOpenURL(_ url: URL, for pushObject: NetmeraBasePush) {
   print("handleOpenURL \(url)")
   if let vc = UIApplication.topViewController() {
     vc.showAlert("App handling link", message: url.absoluteString, .alert, nil)
   }
 }
}

 */
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NetmeraAnalyticsApp")
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

    // MARK: - Core Data Saving support

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


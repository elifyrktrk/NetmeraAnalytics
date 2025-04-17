//// ✅ Updated InboxNotification.swift
//import Foundation
//import NetmeraNotification
//import NetmeraNotificationInbox
//
//
//
//struct InboxNotification {
//    let title: String
//    let body: String
//    let deeplinkURL: URL?
//    let isRead: Bool
//    let timestamp: TimeInterval
//
//    init(from pushNotification: NetmeraInboxPush) {
//        // 1. Title & Body
//        self.title = pushNotification.title ?? "No Title"
//        self.body = pushNotification.body ?? "No Content"
//
//        // 2. Deeplink
//        if let uri = pushNotification.actionData?.uri, let url = URL(string: uri) {
//            self.deeplinkURL = url
//        } else {
//            self.deeplinkURL = nil
//        }
//
//        // 3. Read Status
//        self.isRead = pushNotification.pushStatus == .read
//
//        // 4. Timestamp
//        self.timestamp = (pushNotification.sentTime ?? Date()).timeIntervalSince1970
//    }
//
//    var formattedDate: String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = RelativeDateTimeFormatter()
//        formatter.unitsStyle = .full
//        return formatter.localizedString(for: date, relativeTo: Date())
//    }
//}
////import Foundation
////import NetmeraNotificationCore
////
////struct InboxNotification {
////    let title: String
////    let body: String
////    let deeplinkURL: URL?
////    let isRead: Bool
////    let timestamp: TimeInterval
////    
////    init(from pushNotification: NetmeraInboxPush) {
////        print("Parsing NetmeraInboxPush notification")
////        print("Raw push notification object:", pushNotification)
////        
////        // Debug: Print object type and available properties
////        print("Push object type:", type(of: pushNotification))
////        let mirror = Mirror(reflecting: pushNotification)
////        print("Available properties:")
////        for child in mirror.children {
////            if let label = child.label {
////                print("Property:", label, "Value:", child.value)
////            }
////        }
////        
////        // For now, set default values
////        self.title = "No Title"
////        self.body = "No Content"
////        self.isRead = false
////        self.timestamp = Date().timeIntervalSince1970
////        self.deeplinkURL = nil
////        
////        print("Created notification with default values - will update once we understand the available properties")
////    }
////    
////    var formattedDate: String {
////        let date = Date(timeIntervalSince1970: timestamp)
////        let formatter = RelativeDateTimeFormatter()
////        formatter.unitsStyle = .full
////        return formatter.localizedString(for: date, relativeTo: Date())
////    }
////}

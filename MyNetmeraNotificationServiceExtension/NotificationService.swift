//
//  NotificationService.swift
//  MyNetmeraNotificationServiceExtension
//
//  Created by Elif Yürektürk on 13.05.2025.
//

import UserNotifications
import NetmeraNotificationServiceExtension

class NotificationService: NotificationServiceExtension {
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    super.didReceive(request, withContentHandler: contentHandler)
  }

  override func serviceExtensionTimeWillExpire() {
    super.serviceExtensionTimeWillExpire()
  }
}

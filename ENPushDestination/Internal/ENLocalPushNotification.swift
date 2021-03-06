/**
 (C) Copyright IBM Corp. 2021.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  ENLocalPushNotification.swift
//  ENPush
//
//  Created by Anantha Krishnan K G on 09/02/22.
//

import UIKit
import UserNotifications

class ENLocalPushNotification: NSObject {

    var builder: ENPushNotificationBuilder?
    
    // Optional array of attachments.
    open var attachments: String?

    // The application badge number. nil means no change. 0 to hide.
    open var badge: NSNumber?

    // The body of the notification. Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
    open var body: String

    // The identifier for a registered UNNotificationCategory that will be used to determine the appropriate actions to display for the notification.
    open var categoryIdentifier: String?

    // The sound that will be played for the notification.
    open var sound: String?

    // The subtitle of the notification. Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
    open var subtitle: String?

    // The title of the notification. Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
    open var title: String?

    // Apps can set the userInfo for locally scheduled notification requests. The contents of the push payload will be set as the userInfo for remote notifications.
    open var userInfo: [AnyHashable: Any]?

    public init(body bodyValue: String, title titleVlaue: String? = "", subtitle subtitleVlaue: String? = "", sound soundValue: String? = "", badge badgeVlaue: NSNumber? = 0, categoryIdentifier categoryIdentifierValue: String? = "", attachments attachmentsValue: String? = "", userInfo userInfoValue: [AnyHashable: Any]? = nil) {

        self.attachments = attachmentsValue
        self.badge = badgeVlaue
        self.body = bodyValue
        self.categoryIdentifier = categoryIdentifierValue
        self.sound = soundValue
        self.subtitle = subtitleVlaue
        self.title = titleVlaue
        self.userInfo = userInfoValue
    }

    public func showENPushNotification() {

        let notification = UNMutableNotificationContent()
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        notification.body = self.body
        if self.title != "" {
            notification.title = self.title!
        }
        if self.subtitle != "" {
            notification.subtitle = self.subtitle!
        }
        if self.badge != 0 {
            notification.badge = self.badge!
        }
        if self.categoryIdentifier != "" {
            notification.categoryIdentifier = self.categoryIdentifier!
        }
        if self.sound != nil {
            notification.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: self.sound!))
        }
        if self.userInfo != nil, self.userInfo?.count != 0 {
            notification.userInfo = self.userInfo!
        }

        if self.attachments != nil, self.attachments?.count != 0 {
            if let fileUrl = URL(string: self.attachments! ) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, _, _) in
                    if let location = location {
                        // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try? FileManager.default.moveItem(at: location, to: tmpUrl)
                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl, options: nil) {
                            notification.attachments = [attachment]
                            let request = UNNotificationRequest(identifier: "ENLocalPushNotification", content: notification, trigger: notificationTrigger)
                            if self.builder == nil {
                                struct CustomBuilder: ENPushNotificationBuilder {}
                                self.builder = CustomBuilder()
                            }
                            self.builder?.showENPushNotification(request: request)
                        }
                    }
                }.resume()
            }
        } else {
            let request = UNNotificationRequest(identifier: "ENLocalPushNotification", content: notification, trigger: notificationTrigger)
           // UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            if self.builder == nil {
                struct CustomBuilder: ENPushNotificationBuilder {}
                self.builder = CustomBuilder()
            }
            builder?.showENPushNotification(request: request)
        }
    }

}

protocol ENPushNotificationBuilder {
    func showENPushNotification(request: UNNotificationRequest)
}

extension ENPushNotificationBuilder {
    func showENPushNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

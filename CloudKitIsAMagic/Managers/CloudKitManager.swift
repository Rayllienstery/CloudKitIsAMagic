//
//  CloudKitManager.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 07.06.2024.

import Foundation
import CloudKit
import Combine
import CoreData
import WidgetKit

final class CloudKitManager {
    public static let shared = CloudKitManager()
    fileprivate var disposables = Set<AnyCancellable>()

    private let cloudKitDebugIsEnabled = false

    private init() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink(receiveValue: { notification in
                if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event {
                    if cloudEvent.endDate == nil {
                        debugPrint("Starting an event...")
                    } else {
                        switch cloudEvent.type {
                        case .import:
                            debugPrint("An import finished!")
                            DispatchQueue.main.async {
                                NotificationCenter.default
                                    .post(name: .dataFlowUpdated, object: nil)
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        default: break
                        }
                    }
                }
            })
            .store(in: &disposables)
    }
}

//
//  YZBoxApp.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI
import Parse

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions -----------")
        let configuration = ParseClientConfiguration {
          $0.applicationId = "16vln6zmKJsrTMqln6xiUynxyFGtZ1NUdttgIX7M"
          $0.clientKey = "SF3PhaKGvrZYMWqyEMSn4byyKxq7ZX2OVh5jRZy2"
          $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        return true
        
    }
}

@main
struct YZBoxApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

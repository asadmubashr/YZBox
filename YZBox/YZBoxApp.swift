//
//  YZBoxApp.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI

@main
struct YZBoxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

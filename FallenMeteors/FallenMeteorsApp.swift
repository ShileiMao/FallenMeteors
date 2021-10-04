//
//  FallenMeteorsApp.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 01/10/2021.
//

import SwiftUI

@main
struct FallenMeteorsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

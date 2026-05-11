//
//  Solodko_iOSApp.swift
//  Solodko-iOS
//
//  Created by Taras Kochubey on 11.05.2026.
//

import SwiftUI

@main
struct Solodko_iOSApp: App {
    @State private var authStore = AuthStore()
    @State private var preferencesStore = PreferencesStore()
    @State private var subscriptionStore = SubscriptionStore()
    @State private var foodMemoryStore = FoodMemoryStore()
    @State private var recurringMealsStore = RecurringMealsStore()
    @State private var logStore = LogStore()

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environment(authStore)
                .environment(preferencesStore)
                .environment(subscriptionStore)
                .environment(foodMemoryStore)
                .environment(recurringMealsStore)
                .environment(logStore)
        }
    }
}

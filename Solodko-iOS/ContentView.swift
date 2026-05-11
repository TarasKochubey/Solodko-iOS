//
//  ContentView.swift
//  Solodko-iOS
//
//  Created by Taras Kochubey on 11.05.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FoundationPreviewGallery()
    }
}

#Preview {
    ContentView()
        .environment(AuthStore())
        .environment(PreferencesStore())
        .environment(SubscriptionStore())
        .environment(FoodMemoryStore())
        .environment(RecurringMealsStore())
        .environment(LogStore())
}

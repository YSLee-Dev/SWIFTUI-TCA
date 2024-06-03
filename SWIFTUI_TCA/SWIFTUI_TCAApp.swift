//
//  SWIFTUI_TCAApp.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 5/23/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct SWIFTUI_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(
                    store: Store(initialState: Feature.State()){
                        Feature()
                    }
                )
                .tabItem {
                    Text("Home")
                }
                
                SearchView(
                    store: Store(initialState: SearchViewFeature.State.init()) {
                        SearchViewFeature()
                    }
                )
                .tabItem {
                    Text("Search")
                }
            }
        }
    }
}

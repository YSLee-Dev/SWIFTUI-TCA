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
    let store = Store(initialState: SWIFTUI_TCAFeature.State(contentView: .init(), searchView: .init(), resultView: .init())) {
        SWIFTUI_TCAFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(
                    store: self.store.scope(state: \.contentView, action: SWIFTUI_TCAFeature.Action.contentView)
                )
                .tabItem {
                    Text("Home")
                }
                
                SearchView(
                    store: self.store.scope(state: \.searchView, action: SWIFTUI_TCAFeature.Action.searchView)
                )
                .tabItem {
                    Text("Search")
                }
                
                ResultView(
                    store: self.store.scope(state: \.resultView, action: SWIFTUI_TCAFeature.Action.resultView)
                )
                .tabItem {
                    Text("Result")
                }
            }
        }
    }
}

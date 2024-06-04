//
//  SWIFTUI_TCAFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import Foundation
import ComposableArchitecture

struct SWIFTUI_TCAFeature: Reducer {
    struct State: Equatable {
        var contentView: ContentFeature.State
        var searchView: SearchViewFeature.State
    }
    
    enum Action: Equatable{
        case contentView(ContentFeature.Action)
        case searchView(SearchViewFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
     
        Scope(state: \.contentView, action: /Action.contentView) {
            ContentFeature()
        }
        
        Scope(state: \.searchView, action: /Action.searchView) {
            SearchViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}

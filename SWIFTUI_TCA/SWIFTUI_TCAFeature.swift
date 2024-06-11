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
        var resultView: ResultViewFeature.State
        var nowSeletedTabbarIndex = 0
    }
    
    enum Action: Equatable{
        case contentView(ContentFeature.Action)
        case searchView(SearchViewFeature.Action)
        case resultView(ResultViewFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.contentView, action: /Action.contentView) {
            ContentFeature()
        }
        
        Scope(state: \.searchView, action: /Action.searchView) {
            SearchViewFeature()
        }
        
        Scope(state: \.resultView, action: /Action.resultView) {
            ResultViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .searchView(let searchView):
                switch searchView {
                case .searchBtnTapped:
                    return .send(.resultView(.searchBtnTapped(query: state.searchView.firstNameValue + state.searchView.lastNameValue)))
                default: return .none
                }
                
            default: return .none
            }
        }
    }
}

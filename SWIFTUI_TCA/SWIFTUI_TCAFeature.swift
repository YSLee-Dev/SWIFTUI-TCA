//
//  SWIFTUI_TCAFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SWIFTUI_TCAFeature {
    struct State: Equatable {
        var contentView: ContentFeature.State
        var searchView: SearchViewFeature.State
        var resultView: ResultViewFeature.State
        @BindingState var nowSeletedTabbarIndex = 0
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case contentView(ContentFeature.Action)
        case searchView(SearchViewFeature.Action)
        case resultView(ResultViewFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.contentView, action: \.contentView) {
            ContentFeature()
        }
        
        Scope(state: \.searchView, action: \.searchView) {
            SearchViewFeature()
        }
        
        Scope(state: \.resultView, action: \.resultView) {
            ResultViewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .searchView(let searchView):
                switch searchView {
                case .searchBtnTapped:
                    state.nowSeletedTabbarIndex = 2
                    return .send(.resultView(.searchBtnTapped(query: state.searchView.firstNameValue + state.searchView.lastNameValue)))
                default: return .none
                }
                
            default: return .none
            }
        }
    }
}

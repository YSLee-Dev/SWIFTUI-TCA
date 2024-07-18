//
//  SearchViewFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer

struct SearchViewFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var firstNameValue: String = ""
        var path = StackState<SearchViewPath.State>()
    }
    
    enum Action: BindableAction, Equatable {
        case okBtnTapped
        case binding(BindingAction<State>)
        case path(StackAction<SearchViewPath.State, SearchViewPath.Action>)
        case searchFinished
        case deepLinkForFirstNameInsert(String)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .okBtnTapped:
                state.path.append(.searchTwoStepView(.init(firstNameValue: state.firstNameValue)))
                return .none
                
            case .path(.element(id: _, action: .searchTwoStepView(.backBtnTapped))), .path(.element(id: _, action: .searchTwoStepView(.searchBtnTapped))):
                state.path.removeLast()
                return .none
                
            case .searchFinished:
                state.firstNameValue = ""
                state.path.removeAll()
                return .none
                
            case .deepLinkForFirstNameInsert(let value):
                state.firstNameValue = value
                return .run { send in
                    try await Task.sleep(for: .microseconds(10))
                    return await send(.okBtnTapped)
                }
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            SearchViewPath()
        }
    }
}

extension SearchViewFeature {
    @Reducer
    struct SearchViewPath  {
        @ObservableState
        enum State: Equatable {
            case searchTwoStepView(SearchTwoStepFeature.State)
        }
        
        enum Action: Equatable {
            case searchTwoStepView(SearchTwoStepFeature.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.searchTwoStepView, action: \.searchTwoStepView) {
                SearchTwoStepFeature()
            }
        }
    }
}

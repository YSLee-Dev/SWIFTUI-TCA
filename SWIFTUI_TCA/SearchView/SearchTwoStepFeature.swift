//
//  SearchTwoStepFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 7/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchTwoStepFeature: Reducer {
    struct State: Equatable {
        @BindingState var lastNameValue: String = ""
        var firstNameValue: String
        var isBtnOn: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case searchBtnTapped(String)
        case backBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$lastNameValue):
                state.isBtnOn = !state.firstNameValue.isEmpty && !state.lastNameValue.isEmpty
                return .none
                
            default:
                return .none
            }
        }
    }
}

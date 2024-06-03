//
//  SearchViewFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import Foundation
import ComposableArchitecture

struct SearchViewFeature: Reducer {
    struct State: Equatable {
        @BindingState var firstNameValue: String = ""
        var lastNameValue: String = ""
        var isBtnOn: Bool = false
    }
    
    enum Action: BindableAction {
        case lastNameTFValueInserted(String)
        case btnIsEnableCheck
        case  binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .lastNameTFValueInserted(let value):
                state.lastNameValue = value
                return .send(.btnIsEnableCheck)
                
            case .binding(\.$firstNameValue):
                return .send(.btnIsEnableCheck)
                
            case .btnIsEnableCheck:
                state.isBtnOn = !state.firstNameValue.isEmpty && !state.lastNameValue.isEmpty
                return .none
                
            default:
                return .none
            }
        }
    }
}

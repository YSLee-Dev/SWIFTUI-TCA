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
    }
    
    enum Action: BindableAction, Equatable {
        case lastNameTFValueInserted(String)
        case okBtnTapped
        case  binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

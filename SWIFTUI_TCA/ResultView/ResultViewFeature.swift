//
//  ResultFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/10/24.
//

import ComposableArchitecture

struct ResultViewFeature: Reducer {
    struct State: Equatable {
        var searchResult: [String] = []
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case searchBtnTapped(query: String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: .none 
            }
        }
    }
}

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
        case newResultDataSuccess(data: [String])
    }
    
    @Dependency(\.resultLoad) var resultLoad
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .searchBtnTapped(let query):
                state.isLoading = true
                return .run { send in
                    let result = try await self.resultLoad.querySearch(query: query)
                    print("RUNRUN")
                    await send(.newResultDataSuccess(data: result))
                }
                
            case .newResultDataSuccess(let data):
                state.searchResult = data
                state.isLoading = false
                return .none
            }
        }
    }
}

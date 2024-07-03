//
//  ResultFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/10/24.
//

import ComposableArchitecture

struct ResultViewFeature: Reducer {
    struct State: Equatable {
        var resultDetailState: ResultDetailFeature.State?
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case resultDetailAction(ResultDetailFeature.Action)
        case searchBtnTapped(query: String)
        case newResultDataSuccess(data: [String])
    }
    
    @Dependency(\.resultLoad) var resultLoad
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .searchBtnTapped(let query):
                state.isLoading = true
                state.resultDetailState  = nil
                return .run { send in
                    let result = try await self.resultLoad.querySearch(query: query)
                    print("RUNRUN")
                    await send(.newResultDataSuccess(data: result))
                }
                
            case .newResultDataSuccess(let data):
                state.isLoading = false
                state.resultDetailState = .init(searchResult: .init(uncheckedUniqueElements: []))
                return .send(.resultDetailAction(.newResultDataSuccess(data: data)))
                
            default:
                return .none
            }
        }
        .ifLet(\.resultDetailState, action: /Action.resultDetailAction) {
            ResultDetailFeature()
        }
    }
}

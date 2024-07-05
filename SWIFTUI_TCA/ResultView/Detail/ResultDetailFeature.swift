//
//  ResultDetailFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/27/24.
//

import ComposableArchitecture
import Foundation

struct ResultDetailFeature: Reducer {
    struct State: Equatable {
        var searchResult: IdentifiedArrayOf<ResultDetailModel>
    }
    
    enum Action: Equatable {
        case newResultDataSuccess(data: [String])
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .newResultDataSuccess(let data):
                state.searchResult = IdentifiedArrayOf<ResultDetailModel>(uniqueElements: data.map {ResultDetailModel(id: UUID.init().uuidString, result: $0)})
                return .none
            }
        }
    }
}

//
//  ContentFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 5/30/24.
//

import Foundation
import ComposableArchitecture

struct Feature: Reducer {
    struct State: Equatable {
        // 현재 카운트를 저장하는 State
        var nowCount: Int = 0
        var nowWaiting: Bool = false
    }
    
    enum Action: Equatable {
        // +, - 버튼을 눌렀을 때 작동하는 Action
        case minusBtnTapped
        case plusBtnTapped
        case timerStartBtnTapped
        case timerCancelBtnTapped
    }
    
    enum TimerKey: Equatable {
        case count
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // action 별로 로직 구성
            case .minusBtnTapped:
                if state.nowCount <= 0 {
                    state.nowWaiting = false
                } else {
                    state.nowCount -= 1
                }
                return .none
                
            case .plusBtnTapped:
                state.nowCount += 1
                return .none
                
            case .timerStartBtnTapped:
                if state.nowCount <= 0 {
                    return .none
                } else {
                    let nowCount = state.nowCount
                    state.nowWaiting = true
                    return .run { send in
                        for _ in 0 ... nowCount {
                            try await Task.sleep(for: .seconds(1))
                            await send(.minusBtnTapped)
                        }
                    }
                    .cancellable(id: TimerKey.count)
                }
                
            case .timerCancelBtnTapped:
                state.nowWaiting = false
                return .cancel(id: TimerKey.count)
            }
        }
    }
}

//
//  ResultDetailSheetFeature.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 7/15/24.
//

import ComposableArchitecture
import SwiftUI

struct ResultDetailSheetFeature: Reducer {
    @Dependency(\.dismiss) var dismiss
    
    struct State: Equatable {
        var userSeletedResult: String
        
        var attributedString: AttributedString {
            var string = AttributedString("\"\(userSeletedResult)\" 를(을) 선택하셨습니다.")
            string.font = .title2.weight(.bold)
            if let range = string.range(of: "를(을) 선택하셨습니다.") {
                string[range].font = .subheadline.weight(.medium)
            }
            return string
        }
    }
    
    enum Action: Equatable {
        case okBtnTapped
        case cancelBtnTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancelBtnTapped, .okBtnTapped:
                return .run { send in
                    await  self.dismiss()
                }
            }
        }
    }
}

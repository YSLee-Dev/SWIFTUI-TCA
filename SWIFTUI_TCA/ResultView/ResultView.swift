//
//  ResultView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/10/24.
//

import SwiftUI
import ComposableArchitecture

struct ResultView: View {
    let store: StoreOf<ResultViewFeature>
    var body: some View {
        WithViewStore(self.store, observe: {$0}) {viewStore in 
            Text("ResultView")
        }
    }
}

#Preview {
    ResultView(
        store: Store(initialState: ResultViewFeature.State()){
            ResultViewFeature()
         }
    )
}

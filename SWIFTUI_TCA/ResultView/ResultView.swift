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
            VStack {
                if viewStore.state.isLoading {
                    ProgressView()
                        .progressViewStyle(.automatic)
                        .padding()
                } else if viewStore.state.searchResult.isEmpty {
                    Text("No Searching")
                        .padding()
                }
                
                VStack {
                    ForEach(viewStore.searchResult, id: \.self) {
                        Text($0)
                    }
                }
            }
            
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

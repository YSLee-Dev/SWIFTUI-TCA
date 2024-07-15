//
//  ResultDetailView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/27/24.
//

import SwiftUI
import ComposableArchitecture

struct ResultDetailView: View {
    let store: StoreOf<ResultDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                HStack {
                    Text("맘에 드는 결과를 하나 골라주세요.")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(20)
                    Spacer()
                }
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.searchResult, id: \.id) { data in
                            HStack {
                                Button("\(data.result)") {
                                    viewStore.send(.resultValueTapped(data.result))
                                }
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                
                                Spacer()
                            }
                        }
                        .sheet(store: self.store.scope(state: \.$resultDetailSheetState, action: {.resultDetailSheetAction($0)})) {store in
                            ResultDetailSheetView(store: store)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ResultDetailView(
        store: Store(
            initialState: .init(searchResult: IdentifiedArrayOf(uniqueElements: [
                ResultDetailModel(id: "1", result: "1"),
                ResultDetailModel(id: "2", result: "2"),
                ResultDetailModel(id: "3", result: "3"),
                ResultDetailModel(id: "4", result: "4"),
                ResultDetailModel(id: "5", result: "5"),
                ResultDetailModel(id: "6", result: "6"),
                ResultDetailModel(id: "7", result: "7")
            ]))) {
                ResultDetailFeature()
            }
    )
}

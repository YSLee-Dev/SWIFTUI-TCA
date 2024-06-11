//
//  SearchView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchViewFeature>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {viewStore in
            VStack {
                HStack {
                    TextField(text: viewStore.$firstNameValue) {
                        Text("First Name")
                    }
                    
                    TextField(text: viewStore.binding(
                        get: \.lastNameValue,
                        send: {.lastNameTFValueInserted($0)})) {
                            Text("Last Namet")
                        }
                }
                .padding(.bottom, 20)
                
                Button("Search Start") {
                    print("Btn Tapped")
                    print(viewStore.firstNameValue, viewStore.lastNameValue)
                    viewStore.send(.searchBtnTapped)
                }
                .disabled(!viewStore.isBtnOn)
            }
            .padding(20)
        }
        
    }
}

#Preview {
    SearchView(
        store: Store(initialState: SearchViewFeature.State.init()) {
            SearchViewFeature()
        }
    )
}

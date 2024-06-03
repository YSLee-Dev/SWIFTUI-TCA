//
//  ContentView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 5/23/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                Text("\(viewStore.state.nowCount)")
                
                HStack {
                    Button("-") {
                        viewStore.send(.minusBtnTapped)
                    }
                    .disabled(viewStore.state.nowWaiting)
                    
                    Button("+") {
                        viewStore.send(.plusBtnTapped)
                    }
                    .disabled(viewStore.state.nowWaiting)
                }
            
                Spacer()
                    .frame(height: 40)
                
                if viewStore.state.nowCount != 0 && !viewStore.state.nowWaiting {
                    Button("Timer Start") {
                        viewStore.send(.timerStartBtnTapped)
                    }
                } else if viewStore.state.nowWaiting {
                    Button("Timer Stop") {
                        viewStore.send(.timerCancelBtnTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: Feature.State()){
            Feature()
         }
    )
}

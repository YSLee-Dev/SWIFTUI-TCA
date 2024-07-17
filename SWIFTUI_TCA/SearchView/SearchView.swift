//
//  SearchView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @State var store: StoreOf<SearchViewFeature>
    
    var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path), root: {
            VStack(alignment: .leading) {
                HStack {
                    Text("검색하고 싶은 인물의 성을 입력하세요.")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                TextField(text: self.$store.firstNameValue) {
                    Text("입력")
                }
                .padding(.leading, 10)
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.init(uiColor: .secondarySystemBackground))
                }
                
                Spacer()
                
                Button(action: {
                    self.store.send(.okBtnTapped)
                }) {
                    Text("확인")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.size.width - 40, height: 50)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .cornerRadius(15)
                        }
                }
                
                Spacer()
            }
            .padding(20)
            
        }, destination: { store in
            switch store.state {
            case .searchTwoStepView:
                if let store = store.scope(state: \.searchTwoStepView, action: \.searchTwoStepView) {
                    SearchTwoStepView(store: store)
                }
            }
        })
    }
}


#Preview {
    SearchView(
        store: Store(initialState: SearchViewFeature.State.init()) {
            SearchViewFeature()
        }
    )
}

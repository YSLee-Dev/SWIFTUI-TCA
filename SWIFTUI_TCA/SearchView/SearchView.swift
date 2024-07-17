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
            VStack(alignment: .leading) {
                HStack {
                    Text("검색하고 싶은 인물의 성을 입력하세요.")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                TextField(text: viewStore.$firstNameValue) {
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

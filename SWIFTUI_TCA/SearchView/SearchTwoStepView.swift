//
//  SearchTwoStepView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 7/17/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchTwoStepView: View {
    let store: StoreOf<SearchTwoStepFeature>
    let deviceSize = UIScreen.main.bounds.size
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text("검색하고 싶은 인물의 이름을 입력하세요.")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                HStack {
                    Text("\(viewStore.firstNameValue)")
                        .font(.headline)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.init(uiColor: .systemGray4))
                }
                
                TextField(text: viewStore.$lastNameValue) {
                    Text("입력")
                }
                .padding(.leading, 10)
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.init(uiColor: .secondarySystemBackground))
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {
                        viewStore.send(.backBtnTapped)
                    }) {
                        Text("뒤로가기")
                            .foregroundColor(.black)
                            .frame(width: (self.deviceSize.width / 2) - 30 , height: 50)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(uiColor: .secondarySystemBackground))
                                    .foregroundColor(.white)
                            }
                    }
                    
                    Button(action: {
                        viewStore.send(.searchBtnTapped(viewStore.firstNameValue + viewStore.lastNameValue))
                    }) {
                        Text("검색")
                            .foregroundColor(.black)
                            .frame(width: (self.deviceSize.width / 2) - 30, height: 50)
                            .background {
                                Color(uiColor: .secondarySystemBackground)
                                    .cornerRadius(15)
                            }
                    }
                    .disabled(!viewStore.isBtnOn)
                }
               
                
                Spacer()
            }
            .padding(20)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SearchTwoStepView(
        store: Store(initialState: SearchTwoStepFeature.State.init(firstNameValue: "firstName")) {
           SearchTwoStepFeature()
        }
    )
}

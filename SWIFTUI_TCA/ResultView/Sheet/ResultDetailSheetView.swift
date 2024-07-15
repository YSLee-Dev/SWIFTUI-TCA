//
//  ResultDetailSheetView.swift
//  SWIFTUI_TCA
//
//  Created by 이윤수 on 7/15/24.
//

import SwiftUI
import ComposableArchitecture

struct ResultDetailSheetView: View {
    let store: StoreOf<ResultDetailSheetFeature>
    let deviceSize = UIScreen.main.bounds.size
    
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack(alignment: .leading) {
                Text("결과 선택")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                
                HStack {
                    Text(viewStore.state.attributedString)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Text("Result 화면에도 적용하시려면 확인 버튼을 눌러주세요.")
                    .font(.subheadline)
                    .padding(.bottom, 25)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {
                        
                    }) {
                        Text("취소")
                            .foregroundColor(.black)
                            .frame(width: (self.deviceSize.width / 2) - 30 , height: 50)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(uiColor: .secondarySystemBackground))
                                    .foregroundColor(.white)
                            }
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("확인")
                            .foregroundColor(.black)
                            .frame(width: (self.deviceSize.width / 2) - 30, height: 50)
                            .background {
                                Color(uiColor: .secondarySystemBackground)
                                    .cornerRadius(15)
                            }
                          
                    }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ResultDetailSheetView(
        store: .init(initialState: ResultDetailSheetFeature.State(userSeletedResult: "TEXT")) {
            ResultDetailSheetFeature()
        }
    )
}

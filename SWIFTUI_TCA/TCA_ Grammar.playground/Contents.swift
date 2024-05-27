import SwiftUI

/// TCA (The Composable Architecture)
/// - TCA는 현재 상태를 쉽게 파악하고, 관리하기 쉽게 하기위한 단방향 아키텍처
/// - 단일 진실 공급원을 따르기 위한 단방향 구조로 애플리케이션의 상태, 데이터가 유일한 출처를 가지는 것
/// -> 상태/데이터를 변경시킨 출처가 명확해지며, 그 변경이 예측 / 추적까지 가능해짐

/// State
/// - Reducer의 현재 상태를 갖는 구조체
/// - 비지니스 로직을 수행하거나 UI를 그릴 때 필요한 데이터에 대한 설명을 나타냄
/// - UI를 렌더링 하는데 필요한 데이터가 포함

/// Action
/// - 상태 변화를 일으키는 모든 동작
/// - Enum으로 정의
/// -> 디바이스와 사용자의 액션을 받아오기 위한 타입

/// Reducer
/// - Action을 통해 State를 어떻게 바꿀 것인지 묘사하고, Effect가 존재한다면, Store를 통해 어떻게 실행되어야 하는지 설명하는 Protocol & Property Wrapper
/// -> 작업, 알림, 이벤트 등 기능을 수행하고 State를 변경하거나 API를 호출하는 작업을 진행
/// - Struct에 채택하여 사용
///  내부에 var body: some ReducerOf<Self> or func reduce(){}를 준수해야함
///  - var body는 다른 reducer과 조합해서 사용할 수 있으며, reducer를 조합하고 기능을 구성하는 역할
///  - func는 로직을 func 내부에 구현하며, 다른 reducer하고 조합하지 않을 때 사용

struct Reducer: /*ReducerProtocol*/ {
    struct State: Equatable {
        var count: Int
    }
    
    enum Action: Equatable {
        case minusBtnTapped
        case plusBtnTapped
    }
    
    /*/
    var body: some Reducer<State, Action> {
            Reduce { state, action in
                switch action {
                    
                }
            }
        }
     */
}

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

struct Reducer /*: ReducerProtocol*/ {
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

/// Effect
/// - Reducer의 Action이 반환하는 타입
/// - Action을 거친 모든 결과물
/// - 네트워크 작업, DB 저장 등 비동기 작업을 전담함
/// - 순서를 보장하기 때문에 State가 변경되는 순서도 보장되며, 예측 가능한 결과가 나옴
///
/// Effect는 State를 변경하지만 직접 변경하지 않음
/// - Effect는 작업을 완료, 실패한 후 새로운 Action을 반환하여, 해당 Action을 통해 State를 변경시킴
/// -> Effect는 직접 State를 변경하지 않고, Action을 통해 간접적으로 변경시킴 -> 순수함수적인 성격을 가지고 있음
///
/// Effect 중 예상과 다른 결과물은 Side Effect라고 칭함
/// - Side Effect는 Effect와 명확하게 분리시켜, 가독성 및 추론성을 증가시킴
///
/// Action과 Effect
/// - Action은 사용자 이벤트, 시스템 이벤트를 받아 동기적으로 State를 업데이트
/// - Effect는 비동기 작업을 처리하고 그 결과를 Action으로 반환하는 역할을 수행함 -> 직접적으로 State를 변경시키지 않음
///
/// Effect의 종류
/// 1. .none
/// - 아무런 동작하지 않는 Effect를 반환
///
/// 2. .send()
/// - 파라미터로 Action을 전달할 때 사용
/// - 특정 동작 이후 추가적인 동기 Action이 필요할 때 사용
///
/// 3. run{}
/// - 비동기 작업을 래핑할 때 사용
/// - 인자로 비동기 클로저를 받아서 실행하며, 클로저 {} 내부에서 send를 사용하여, Action을 시스템에 전달할 수 있음
/// -  send는 2번의 .send()와 다름
/// -> 2번의 .send()는 Action를 바로 반환하지만, send는 비동기 작업의 결과를 Store로 보내는 역할을 수행함 + 클로저 내부에서만 유효
///
/// 4. cancel(), cancellable()
/// - 비동기 작업이 진행 중인 Effect를 취소할 때 사용
/// - cancellable에는 취소 시 요청할 ID 값을 넣을 수 있음
/// -> ID는 Hashable만 준수하면 어떤 타입도 사용 가능
///
/// - cancellable로 등록한 id를 cancel로 호출(return)하면 비동기 작업을 취소할 수 있음
///
/// 5. .merge, .concatenate
/// - Effect를 여러 메서드에 전달하는 것
/// -> .send, .run 등 Effect로 전달 가능
/// - merge는 순서를 보장하지 않지만 concatenate는 순서를 보장함
///
/// Store
/// - Store는 APP 런타임동안 Reducer의 인스턴스를 관리하는 객체
/// -> Class 타입, View 구조체 안에서 주어진 초기 상태와 Reducer를 사용하여 초기화함
/// - State, Action을 관리하며 변화를 감지하고 Action을 실질적으로 처리함
///
/// Store는 ViewModel과 비슷하지만 다름
/// - Store와 ViewModel은 동일하게 상태를 관리하고, 뷰에 제공함 & 사용자의 입력/이벤트를 처리함
/// - 하지만 Store는 Reducer, Effect, State등을 사용해 앱의 상태, 비지니스 로직을 구성하지만, ViewModel은 개발자의 구현방식에 따라 다름
/// - Store는 비동기 작업을 Effect로 명확하게 처리하지만, ViewModel은 RxSwift, Combine등 다양한 방식으로 처리함
/// - Store는 Reducer를 소유하고 관리하지만, ViewModel을 직접 생성하여 사용함
///
/// Store.scope()
/// - 하위 State, Action을 다루는 Store로 변환할 수 있는 메소드
/// -> 상위 View에서 하위 View로 Store를 넘길 때 모든 State, Action를 넘길 필요는 없음, 하위 View에 맞게 범위를 나눌 때 사용함
/// - 작은 범위의 Store를 사용하면, View는 필요한 State, Action에만 접근할 수 있기에 모듈화/유연성을 가질 수 있음
///
/// ViewStore
/// - Store와 다르게 View에 필요한 상태만 구독하고 업데이트함
/// - Store를 감싸고 있는 객체로 View와의 상호작용을 단순화하기 위해서 사용
/// -> 모든 값을 부모 Store에 올릴 경우 렌더링, 값이 중복될 수 있음
/// - State를 보유하지 않고, 구독하는 역할만 수행함
///
/// Scope를 통해 Store의 State/Action을 일부분만 가져온 후 굳이 ViewStore로 변환해 사용하는 이유는
/// - Store를 ViewStore로 바꾸면 Store를 자동으로 구독하여 State가 변화할 때마다 View가 업데이트 됨
/// - State를 쉽게 읽을 수 있는 속성을 제공함
/// - View 내부에 직접 Store를 만들지 않고, 매개변수로 동작할 수 있게 도와줌
///
/// withViewStore
/// - View와 Store를 View 빌더에서 사용할 수 있는 ViewStore로 변환해줌
/// - withViewStore가 감싸고 있는 View가 복잡해질 경우 컴파일 성능이 떨어질 수 있음
/// - 타입을 명시하거나, init으로 Store를 주입받고 ViewStore를 생성하면 연산을 줄일 수 있음

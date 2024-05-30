import SwiftUI

/// Binding
/// - SwiftUI에서는 @State, @Binding 프로퍼티 래퍼를 통해 View의 상태를 적용, 관리할 수 있음
/// - 단, SwiftUI의 프로퍼티 래퍼는 양방향으로 통신하기에, 복잡해진 State를 관리할 때 Side Effects를 관리하기 어려움
///
/// TCA에서는 Binding을 고유한 State 관리 도구를 이용해서 적용/관리함
/// - TCA 원칙에 맞춰 단방향 데이터 흐름을 따룸
/// - State 변화에 따른 Side Effects도 일괄되게 처리할 수 있고, 변화 로직을 명확하게 파악할 수 있음
/// - SwiftUI의 View와 효율적으로 연동해서 사용할 수 있음
///
/// Binding(get: set:)
/// - 기본적인 바인딩 형태
/// - get에는 State를 바인딩 값으로 변환하는 값을 넣음
/// - set에는 바인딩 값을 Store에게 전달하는 Action으로 변환하는 클로저
///
/// - Binding()은 Action의 정의가 각 State 마다 필요하고, Reducer 또한 Action의 정의만큼 필요하게 되어 비효율적일 수 있음
///
/// TCA의 Binding을 위한 프로퍼티 래퍼를 사용할 경우 효울적으로 Binding 할 수 있음
///
/// @BindingState
/// - SwiftUI의 UI 컨트롤에 State를 바인딩 가능하게 하는 프로퍼티 레퍼
/// - @State 처럼 사용할 수 있게 도와줌
///
/// BindingAction
/// - @BindingState는 Action이 BindingAction 프로토콜을 채택하고 구현해야함
/// - 구현은 case 중 하나가 BindingAction<State> 값을 보유해야함
/// - State 값을 case가 보유하기 떄문에 State를 한 case에서 처리할 수 있음
/// - @Binding과 비슷한 역할을 수행함
///
/// BindingReducer()
/// - Reducer은 BindingReducer() 함수를 호출하여, BindingAction이 수신된 경우 State를 자동으로 업데이트 하는 로직을 추가함
/// - Reducer body 내부에서 동작하며, View 내부에서는 BindingAction이 직접 호출되지 않지만, BindingReducer은 Action을 취급하고 있음
/// -> SwiftUI의 View로 인해 값이 변경된 경우(BindingState 값) BindingReducer()은 업데이트 된 State 값과 함께 Action을 수신하고, Reducer 클로저 내에 도메인 로직을 처리하게 됨
///
/// --> View 데이터 입력 > @BindingState 래퍼의 값이 변경되면, BindingAction을 생성함 > Store에 전달됨 > Store에 전달된 Action은 Reducer를 통해 처리하게 됨 > Reducer은 BindingAction을 처리하여,  State를 업데이트 하게 됨 
///

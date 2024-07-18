import SwiftUI

/// Navigation
/// - SwiftUI의 Navigation Stack, UIKit의 UINavigationController가 제공하는 drill-down 방식의 화면 전환
/// - TCA에서는 drill-down이 Navigation으로 간주되면, Sheet, Full Screen Covers도 Navigation의 일종이 됨
/// - TCA에서는 Sheet, Covers도 Navigation으로 간주되면, popovers, alert도 Navigation의 일종이 됨
///
/// TCA에서 Navigation은 앱의 모드를 변경하는 것을 의미함
/// - drill-down에 속하는 sheet, push, alert 등은 앱의 모드 변경을 수행하는 요소
///
/// 모드변경?
/// - 어떤 상태가 존재하지 않았던 상태에서 존재하게 되거나, 그 반대의 상태가 되는 것
/// -> Navigation.push를 통해 새로운 View를 존재하게 하거나, pop을 통해 View를 제거하는 것이 모드가 변경되는 것
///
/// TCA에서 Navigation은 앱의 화면 전환을 관리하는 기능을 의미함
/// - State/Action을 사용하여 Navigation을 처리 (SwiftUI 기반코드 X)
/// - 트리기반의 Navigation, 스택기반의 Navigation으로 존재함
///
/// 트리기반의 Navigation
/// - 상태의 존재 여부를 (모드에 대한) 옵셔널, 열거형으로 정의하여 표현하는 것
/// - Navigation의 상태가 중첩될 수 있음을 의미하고, 트리와 같은 구조를 형성할 수 있음
/// -> 부모 Navigation에 자녀 Navigation이 들어갈 수 있음
/// -> 부모 Navigation에 자식 Navigation 개수는 계층 수 만큼 있을 수 있으며, 부모 init 시 구성할 수 있음 (선택)

struct 부모State {
    //@PresentationState var child1: 자녀1State?
}
struct 자녀1State {
   // @PresentationState var child2: 자녀2State?
}

/// 스택기반의 Navigation
/// - 상태 존재 여부를 컬렉션 타입으로 정의하여 표현하는 것
/// - SwiftUI의 Navigation Stack에서 활용됨
/// - 스택 전체에 있는 기능들이 데이터 컬렉션으로 표현됨
/// -> Item이 추가되면, 새로운 기능이 추가되는 것을 의미 -> Navigation 될 수 있는 것
/// - 스택에서 Navigation 가능한 모든 기능을 Enum을 사용하여 정의
/// - Path를 사용하여 스택을 정의하며, 기능을 나타냄
/// -> 계층의 깊이에 따라서 길어질 수도, 짧아질 수도 있음

enum Path {
   // case detail(자녀1.State)
    // case detail2(자녀2.State)
}
let path: [Path] = [
    // .detail(자녀1.State),
    // .detail2(자녀2.State)
]

/// 앱에서는 트리와 스택구조를 혼합해서 사용함
/// - 앱 Root에서는 스택기반을 사용하지만, 각 Feature에서는 sheet, popup등을 위해 트리 구조를 사용할 수 있음
///
/// 트리구조의 장/단점
/// - 간결하게 Navigation 방식을 모델링 할 수 있음
/// -> 앱에서 가능한 모든 Navigation을 정적으로 설명할 수 있으며, 유효하지 않은 Navigation 경로는 사용하지 않음
/// -> sheet, popover, alert 등도 표현할 수 있음
/// - 앱에서 지원하는 Navigation의 경로 수를 제한할 수 있음
/// - 앱의 기능을 모듈화 하면서 트리구조를 사용한 경우, 독립적으로 구성되기 때문에 모듈화로 인한 테스트가 용이함
/// -> previews에서도 특정 View만을 확인할 수 있음
/// - 복잡하거나 재귀적인 Navigation 경로에서는 번거로울 수 있음
/// - 트리기반은 서로 결합되어 작동하기 때문에 컴파일 시간이 늦어질 수 있음
///
/// 스택구조의 장/단점
/// - 재귀적인 Navigation 경로를 쉽게 처리할 수 있음
/// - 스택에 포함된 기능은 다른 화면에서 분리될 수 있음
/// -> 다른 기능을 컴파일 하지 않아도 됨
/// - 트리구조 대비 안정적임
/// - 비논리적인 구조의 Navigation이 표현될 수 있음
/// -> 자식 -> 부모와 같은 Navigation 선언을 막을 수 없어, 개발자의 실수를 유발할 수 있음
/// - 다른 기능을 컴파일 하지 않고 독립적으로 실행되기 때문에 다른 기능은 비활성화됨
/// -> previews에서 모든 기능을 테스트 할 수 없고 직접 빌드 해야함
/// - 다른 기능과 독립적으로 동작하기 때문에 단위 테스트 시 어려움
/// -> 상호작용을 테스트 하기 어려움
/// - sheet, popover, alert 등은 지원하지 않음

/// 트리기반
/// - 옵셔널, 열거형을 사용하여 Navigation을 모델링함
/// - Navigation의 깊이를 간편하게 구성할 수 있고, 이후 작업은 SwiftUI가 전담함
/// -> 앱 어느 곳으로도 딥링크 생성이 가능
///
/// @PresentatationState, PresentatationAction, ifLet 등을 사용하여 사용할 수 있음
/// - 트리 기반은 자식의 State, Action과 밀접하게 관련이 있기 때문에 ifLet을 통해 자식의 Reducer를 생성해 주는 방식으로 이용
/// -> 자식의 State가 Nil이 아닌경우 표시, Nil인경우 제거..
///
/// 옵셔널 방식
/// - 부모 State에 @PresentatationState를 준수하는 자녀 State와 Action을 추가함
/// - ifLet을 사용하여 자식 State가 Nil이 아닐 때 사용하는 Reducer를 정의
/// - View에서는 각 연산자를 이용해 store를 주입하고, View를 생성시킴 (scope로 분리 필수)
/// - sheet, alert, popover, navigationDestination 등이 존재
///
/// 열거형 방식
/// - 도메인 모델링에 있어서는 좋지 않은 방식일 수 있음
/// - 한 화면에서 옵셔널 값을 동시에 여러개 가지게 될 때 Nil이 아닌 상황이 발생할 수 있음
/// -> A에서도 C화면으로, B에서도 C 화면으로 접근이 가능한 경우
/// - 이러한 문제를 방지하기 위해 열거형으로 1차 모델링을 걸침
///
/// State를 Enum으로 정의함
/// - 컴파일 시 하나의 목적지만 사용이 가능함을 증명함
/// - 열거형 방식만 단독적으로 사용하는 것이 아닌, 옵셔널 방식과 같이 사용하여, 화면 Navigation만을 전담으로 하는 Reducer를 생성 후 해당 Reducer를 최상위 부모가 옵셔널로 소유함으로 사용하는 것이 효율적
/// -> 화면 전담 Reducer는 이동 가능한 모든 방식을 Enum(state, Action)로 정의하며, body 내부에는 각각의 scope에 따른 Reducer를 정의함 -> 최상위 부모는 해당 Reducer를 옵셔널 값으로 사용하고 있다가 필요 시 case 값을 전달하여 특정 Feature만 init 하는 방식으로 사용
///
///  미리 Scope를 통해 Feature의 Reducer를 정의하면 메모리 낭비가 아닐까..?
///  - TCA는 상태 변화가 이루어지기 전까지 초기화 되지 않음
///  - 또한 Action으로 전달된 특정 Reducer만 초기화 됨
///
///  트리기반의 Navigation은 모든 형태의 Navigation을 단일 API 스타일로 통합할 수 있음
///  - 부모, 자식의 Reducer를 통합하는건 ifLet으로 가능함
///  -> push, pop, alert 등을 가리지 않음
///
///  Dismiss는 ifLet을 사용하기 때문에 자식의 State 값을 Nil로 주입하면, 종료됨
///  - 자식 자체에서도 @Envioment 프로퍼티 래퍼의 Dismiss를 사용한 경우 내부에서 부모를 찾아서 Nil, false를 주입하여 Dismiss가 가능함
///  -> 단, 비동기 작업 등 복잡한 로직에서는 사용이 어렵기 때문에 View 내부에서만 사용하는걸 권장함
///  -> Reducer 내부에서 사용하는 Dismiss는 DismissEffect를 이용, 단, 비동기 작업 시 유의해야함
///
///  스택기반
///  - 컬렉션 상태를 사용해 네비게이션을 모델링함
///  - 1차원 데이터 컬렉션을 구성하여, SwiftUI에 전달 -> 딥링크가 가능
/// - StatckState, StatckAction, ForEach등을 사용하여 구성
///
/// 스택 기반은 아래와 같은 순서로 구성
/// 1. 기능들의 도메인 통합
/// - Path로 불리는 새로운 Reducer를 정의하여, 스택에 정의 될 수 있는 모든 도메민을 추가시킴
/// -> Path는 RootReducer 내부에 위치 (State는 Enum)
/// -> 트리형의 열거형을 사용하는 방식과 동일 -> 모든 방식을 추가
/// - Path의 각 State는 해당 View의 init을 책임지는데, 만약 해당 View가 의존적이지 않다면, 바로 init을 할 수 있음
///
///  - 위 작업을 통해 RootReducer -> PathReducer -> 하위 Reducer가 전부 연결되어, 자식의 Action을 호출하여 작업할 수 있음
///
/// 2. Navigation 스택을 관리하는 State, Action 추가
/// - 부모 Reducer의 State, Action에 StackState, StackAction을 준수하게 추가
///
/// 3. ForEach를 통해 부모와 자녀의 Reducer를 연결, 통합함
///
/// 4. 부모, 자식 View를 결합
/// - NavigationStackStore를 이용함
/// -> Path에는 Store를 Scope로 나누어서 사용
/// -> destination은 State에 따른 View를 CaseLet으로 사용하여 정의
/// - 컴파일 시 Path State는 모든 Case가 처리되었음을 보장함
///
/// - NavigationStack으로도 사용이 가능함
/// -> NavigationStack의 path는 store를 scope로 나누어 사용
/// -> 버튼 클릭 시 push,pop 등을 원하는 경우 NavigationLink를 사용함
/// -> NavigationStack 또한 destination 정의가 필요함
/// + 단, 위 NavigationStack을 사용할 때에는 Reducer의 State가 @ObservableState 매크로를 준수하고 있어야 하며, Store는 ViewStore로 변환하지 않고, @State 프로퍼티 래퍼를 붙여서 사용함
///
/// 결합이 완료된 경우 Navigation 스택 내부에 바로 접근이 가능함
/// - StackAction을 이용하여 패턴을 매칭하고, 진행함
/// - StackAction에는 내부의 ID를 통해 자동으로 관리하며, ID를 통해 pop, 원소 접근 등이 가능함
/// -> Array처럼 특정 Index에 있는 View에 바로 접근이 가능하며, 제거할 수도 있음
///
/// - 부모 Reducer에 있는 Path는 State와 연결되어 있기 때문에 Body 내부에서 사용할 수 있음
/// -> StackAction은 Path.State, Path.Action을 전부 가지고 있음
/// -> StackAction을 통해 특정 Action이 일어날 때 State를 변경하거나 Push/dismiss 할 수 있음
///
/// Element(id_, action:)
/// - 해당 ID의 Stack에 접근하여, Stack Action 값에 접근
/// - ID 값은 자동으로 생성되기 때문에 개발자는 _로만 표현하여 사용
///
/// Dismiss는 Path에 popLast()를 사용하여, Dismiss 할 수 있음
/// - 단, 해당 스택에 바로 접근이 가능해야하는데 이경우는 부모만 가능함
/// - 자식이 바로 Dismiss 하는 법은 트리구조와 동일함
///
/// StatckState VS NavigationPath
/// NavigationPath
/// - SwiftUI에서 네비게이션 스택의 컨텐츠를 관리하고 데이터 모델링 시 사용
/// - TCA에서는 NavigationPath를 사용하지 않고, StackState를 사용
///
/// NavigationPath는 타입이 제거되어 있기 때문에 Hashable 속성을 가진 모든 데이터를 넣을 수 있으며, 데이터 타입에 따라 View를 분리할 수도 있음
/// - 단, 타입이 제거 되어 있기 때문에 스택의 마지막 값 제거, 개수 확인만 할 수 있을 뿐 Type과 관련된 메소드는 사용할 수 없음
/// -> 특정 Index를 추출하거나, ForEach로 순환할 수 없음
///
/// TCA는 NavigationPath를 사용할 경우 전체 스택 데이터를 집계하기 어렵고, path 내부를 순회할 수 없기 때문에 자체 StackState를 사용함
/// - StackState는 NavivationPath와 비슷한 용도로 사용되지만, 타입화 되어 있으며, 여러가지 속성을 사용할 수 있음

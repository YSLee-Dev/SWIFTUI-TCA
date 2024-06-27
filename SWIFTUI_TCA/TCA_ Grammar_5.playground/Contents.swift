import SwiftUI

/// MultiStore
/// - 하나의 Reducer로 모든 Action, State를 관리하기 어려움
/// - 요구에 맞게 잘게 쪼개 사용하고, 관리하는 것이 MultiStore
///
/// - MultiStore는 자식 State가 없어도, 특정 케이스에서 자식 View를 렌더링 할 수 있고,
/// - Reducer를 잘게 쪼개서 독립적으로 동작하게 할 수 있음
///
/// Scope()를 통해 Store의 자식로 나누는 것과 MultiStore는 무슨 차이가 있나?
/// - Scope를 통해 자녀로 나눌 경우 부모 State는 해당 자식 State를 부모 State init 시 가지고 있어야함
/// - 자식이 항상 노출되지 않는 View거나, 같은 동작을 여러번 반복할 수 없는 경우 init 시 State를 생성하는 건 비효율적임
/// - 이에 따라 TCA는 자녀의 State를 알고는 있되, 옵셔널하게 가지고 있다가, 필요할 때 init 해서 사용하는 것
/// -> 사용이 끝난 경우 nil 처리도 가능함
///
/// ifLet
/// - 부모 State가 자녀 State를 옵셔널로 가지고 있을 때 사용
/// - 자식의 State가 옵셔널일 때 부모의 Reducer에서 keypath, casepath로 지정하여 자식 Reducer를 가져올 수 있고, 실행할 수 있음
/// -> 자녀 State에 Nil 값이 아닌 값이 감지된 경우 자녀 Reducer를 실행함
///
/// - 매개변수로 부모 내부에 있는 자식 State, Action을 가지게 되며, 자식 State가 nil이 아닐 때 동작할 Reducer를 정의함
/// - 반환 값은 래핑된 State, Action이 부모 + 자식이 동일해야 하며, 자식 Reducer가 ReducerProtocol을 만족해야, 부모와 자식을 결합한 Reducer를 반환함
///
/// - 정확성을 위해 ifLet은 자식 Reducer를 먼저 실행 후 부모 Reducer를 실행함
/// - 자식 State가 도중에 nil이 되거나, alert 같은 action이 감지되면 자식 상태를 무시/취소함
///
/// ifLetStore
/// - 자식 State가 있을 때 자식 View를 보여주거나, 없다면 특정 View를 보여주고 싶을 때 사용
/// -> ifLet을 통해 Reducer와 연결 후 View에서 표현할 때 사용
///
/// - IfLetStore는 struct으로 구성되어 있으며, init으로 옵셔널한 자식 State, Action, View를 넣게됨
/// - then은 state가 옵셔널이 아닐 때, else는 state가 옵셔널일 때 표현 할 View를 넣음 (else는 옵셔널)
/// - 내부에는 store가 nil 일 때를 감지하여 nil 값을 무시하며, nil 값에 따라 View를 다르게 리턴함
/// + 내부에서 리턴하는 View는 이미 Store와 withViewStore를 통해 연결되어 있음
///

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
/// + 자녀 State가 Nil 값이 아닌 값을 가지는 건 개발자가 직접 init을 해주어야 함 (ifLet이 자식의 Action을 감지하더라도 직접 init 하지 않음)
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
/// forEach
/// - 자식의 State가 컬렉션 타입일 때 forEach를 통해서 부모 로직과 자식 로직을 수행할 수 있게 함
/// -> 부모 State에 자식 State가 컬렉션 타입일 때 사용할 수 있음
/// - ID를 사용하여 안전하게 접근하기 위해 IdentifiedArray 타입을 사용함
/// - forEach도 동일하게 자식 -> 부모 순서로 호출됨
/// - 매개변수로는 자식의 State, Action을 keypath, casepath로 전달하며, 클로저로 각 reducer를 return 해야함
///
/// IdentifiedArray?
/// - 객체의 컬렉션 타입을 처리할 때 사용하며, 각 객체들이 고유한 식별자를 가지고 있어야 할 때 사용함
/// - 내부 타입은 Identifiable 프로토콜을 채택해야 하며, 채택한 타입은 "id"라는 고유 식별자를 제공해야함
/// -  Identifiable<Type>을 통해 정의
///
/// forEachStore
/// - 배열된 State를 순회하며, 각 항목에 맞는 View를 생성하는데 사용됨
/// -> 자녀의 State를 순회하며 View를 생성함
/// - 생성자로 scope를 통해 부모 store를 분리하여 자녀 store를 넣어야하며, 각 고유 ID를 넣어야함
/// - 클로저로 scope된 store를 제공하며, View를 return 해야함
///
/// ifCaseLet
/// - 부모 State가 Enum 타입이고, 자식이 State를 가질 때 특정 케이스에 대해 자식 Reducer를 실행할 때 사용
/// -> 자식 Action이 발생하면, 특정 자식의 Reducer를 실행하는 것
/// - ifCaseLet도 동일하게 자식 -> 부모 순서로 호출됨
///
/// SwitchStore
/// - ifCaseLet과 동일하게 State가 Enum 타입으로 되어있을 때 Case에 따라 View를 표출할 수 있음
/// - Swtich를 통해서 자식을 나눈 경우 caseLet을 통해 특정 자식의 State/Action만 처리하는 Store를 만든 후 클로저로 View를 리턴함 (Scope와 비슷하지만 다름)
/// - 단, 1.7 버전 이상부터는 if let 구문으로 사용

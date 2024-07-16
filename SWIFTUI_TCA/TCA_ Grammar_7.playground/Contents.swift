import SwiftUI

/// TCA에서는 매크로를 이용하여 Reducer를 정의하고 다양한 기능을 사용할 수 있음
///
/// 매크로란?
/// - Swift 5.9에서 추가된 기능
/// - 컴파일러를 수정하지 않고, Swift 패키지에 배포할 수 있는 방식으로, Swift의 기능을 추가할 수 있음
///
/// Swift는 표현적인 코드와 API를 작성하는데 효율적임
/// - 반복적인 코드, 보일러 플레이트 코드를 작성하지 않게 도와줌
/// -> 프로퍼티 래퍼, Result Builder 등
/// - 간단한 코드를 작성하면, 컴파일러가 복잡한 코드로 확장해줌
/// -> 상단의 기능들은 이미 배포된 Swift 컴파일러에 내장되어 있음
///
/// - 기존 기능이 원하는 기능으로 수행될 수 없다면, Swift 컴파일러에 기능을 추가해야함
/// -> 하지만, 공식적으로 컴파일러에 추가가 되려면 시간도 오래 걸리고, 복잡함
/// -> 컴파일러에 기능을 추가하지 않고, 사용할 수 있는 매크로를 사용하는 것
///
/// 매크로는 사용을 명확하게 명시해야함
/// Freestanding
/// - #기호로 시작하며, 코드에서 다른 항목으로 대체함
///
/// Attched
/// - @기호로 시작하며, 코드의 선언에서 속성으로 사용함
/// - #, @ 기호가 없다면, 매크로가 아님
///
/// 매크로에 전달된 코드와 매크로에서 전송된 코드는 완전해야 하며, 실수를 검증해야함
/// 매크로 확장은 예측이 가능해야함
///
/// TCA에서는 @Reducer를 통해 Reducer Struct이 Reducer 프로토콜을 채택하지 않아도, Reducer 기능을 수행할 수 있게 함
/// + Action 등 Enum을 사용할 때 \.로 바로 접근이 가능하게 함
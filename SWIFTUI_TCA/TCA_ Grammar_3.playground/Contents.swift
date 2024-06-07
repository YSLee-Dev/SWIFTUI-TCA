import SwiftUI

/// Dependency
/// - 의존성을 관리하기 위해 사용함
/// - 기존에는 의존성 주입을 통해 의존성을 관리했지만, TCA에서는 TCA Dependency 라이브러리를 통해 관리함
///
/// 의존성은 DB, 네트워크 작업 등이 있음
///- 기존 의존성은 SwiftUI preview Mock 데이터를 준비하지 않거나, 테스트 Mock을 준비하지 않으면 사용이 어려웠는데 TCA Dependency는 이를 고려해서 만들어짐
///
/// @Dependency 
/// - 프로퍼티 래퍼를 사용하여 정의함
/// - 직접 생성자를 호출하지 않고 미리 정의해 놓은 값을 key path로 불러와서 사용함
/// -> 의존성 추가를 먼저한 후 진행
///
/// DependencyKey
/// - DependencyValues에 의존성을 추가하기 위해서 사용하는 프로토콜
/// - 프로토콜 내부에는 liveValue, previewValue, testValue를 정의할 수 있음
/// -> 각각 실제 동작에서 사용할 Value, SwiftUI preview 시 사용할 Value, testValue에서 사용할 Value로 나누어지며, liveValue는 반드시 return 해야함
///
/// - Value 값은 값 타입 뿐만 아니라 객체가 올 수 있으며, static 타입으로 선언되어야 함
/// - Value의 타입은 3개 모두 동일 해야함
/// -> live, test, preview가 공통으로 사용하는 프로토콜을 만들고 이를 채택하여 쓰는게 효율적이고 테스트하기 좋음
///
/// DependencyValue
/// - DependencyKey를 통해 의존성을 return 하기 위해 사용함
/// - DependencyValue는 개발자가 직접 생성하지 않으며, 선언되어 있는 DependencyValue에 원하는 의존성을 extension 해서 사용함
/// -> Extension 시에는 DependencyKey를 사용하며, get/set을 가지는 프로퍼티로 구현
/// - DependencyValue는 subsciprt가 구현되어 있기 때문에 []로 접근하여 구현할 수 있음
///
/// @Dependency는DependencyValue를 확장한 타입으로, Key path를 통해 DependencyValue 타입의 인스턴스를 가져와 사용하는 구조로 되어 있음

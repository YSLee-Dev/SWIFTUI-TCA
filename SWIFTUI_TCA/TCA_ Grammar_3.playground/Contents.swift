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
///
/// Dependency는 내부에 @TaskLocal을 통해 종속성을 관리하고 있음
/// - @TaskLocal은 Swift Concurrency 모델에서 사용되는 속성 중 하나로, Task 내에서만 유효한 지역 변수를 선언할 수 있게 함
/// - @TaskLocal은 전역변수와 비슷해보이지만, 동시 접근에 대해 안정성을 보장하며, 특정 범위 내에서만 값을 수정할 수 있으며, @TaskLocal은 Task{}를 상속하게 됨

enum Key {
    @TaskLocal static var oneValue = 1
}

print("1", Key.oneValue)

Key.$oneValue.withValue(10) {
    print("2", Key.oneValue)
}

print("3", Key.oneValue)

/// @TaskLocal는 withValue를 통해서만 값이 변경되게 되며, {해당 스코프가 끝나면} 값 변화는 이루어지지 않음
/// - 이로인해 안전하고, 값 추론이 가능해짐
/// - Key.oneValue = 2 로 값을 직접적으로 대입할 수 없음
///
/// {스코프 이외에도 변경된 값을 유지하고 사용하려면}, 로컬 상속을 이용하게 됨
/// - TaskGroup, async let, Task{}를 통해 생성된 작업은 순간에 바로 @TaskLocal을 상속받게 됨
/// - 상속된 값은 스코프와 동일하게 사용할 수 있음
/// - 단, TaskLocal은 모든 이스케이프 컨텍스트에서 상속하지 않음 -> DispatchQueue 등은 상속받지 않음

Key.$oneValue.withValue(10) {
    print("4", Key.oneValue)
        
    Task {
        try await Task.sleep(for: .milliseconds(100))
        print("5", Key.oneValue) // sleep으로 인해 withValue 스코프를 벗어났음에도 10이 출력됨
    }
}

/// 이와 같이 Dependency는 TaskLocal을 통해 종속성을 관리하기 때문에 Task에도 동일하게 상속 받음
/// - withDependency()를 통해서 Dependency를 override 한 후 후행 클로저를 통해서 override한 Dependency를 받아서 사용할 수 있음
/// - TaskLocal과 동일하게 {클로저 내부에서만 override 구문이 적용됨}
/// - 단, 상위 객체에서 하위 객체를 생성할 때에는 (from:)을 통해 부모의 종속성을 자식에게 상속해주어야 함

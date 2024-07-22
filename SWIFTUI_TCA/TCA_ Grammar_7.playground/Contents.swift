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
///
/// ObservableState
/// - TCA 1.7 이하 버전에서는 Reducer를 정의 후 View에서 사용하려면, withViewStore를 통해 ViewStore 형태로 사용해야 했음
/// -> ViewStore는 Store를 감싼 형태로 View와 Store를 연결해주며, State 변화 시 View를 업데이트 시킴
/// --> 실제로 ViewStore는 @ObservedObject를 준수하고 있음
///
/// TCA에서는 컴파일러 성능을 개선 시키면서 withViewStore 대신 viewStore를 따로 생성하여, @ObservedObject로 관리하라고 추천함
/// - withViewStore는 View가 복잡해질 경우 성능 이슈가 있음
/// - 하지만, View마다 ViewStore를 생성할 경우 보일러플레이트 코드가 심해짐
///
/// ObservableState는 매크로로, Reducer 내부 State에 붙일 경우 State를 Observable하게 함
/// - ViewStore, withViewStore를 작업하지 않고도 바로 View에서 사용이 가능함
/// -> 단, iOS17부터만 바로 사용 가능하며, iOS16 이하는 withPerceptionTracking{}로 감싼 뷰를 사용해야함
///
/// ResultBuilder
/// - 속성 중 하나로 객체에서 사용할 수 있고, 중첩된 데이터 구조를 만드는데 유용함
/// - 일종의 매크로 같은 성격을 가지고 있기 때문에 컴파일시 코드를 자동으로 수정함
/// - 여러 함수를 통해 여러 데이터를 한번에 묶는 역할을 수행함
/// - 다른 타입을 특정 타입으로 변환할 수 있고, 옵셔널, if, for 등 구문 사용이 가능함 (값은 클로저로 추가)
/// - SwiftUI의 Body도 내부에서 ResultBuilder를 사용한 ViewBuilder를 사용 중임
/// - resultBuilder를 사용하면 불변의 값으로 처리되기 때문에 append와 같은 메서드는 사용할 수 없음 (새로운 배열을 생성해야 함)
/// - return 키워드를 생략함

struct Country {
    var name: String
}

@resultBuilder
struct CountryBuilder {
    static func buildBlock(_ components: [Country]...) -> [Country] {
        Array(components.joined())
    }
    
    static func buildExpression(_ expression: Country) -> [Country] {
        [expression]
    }
    
    static func buildExpression(_ expression: [Country]) -> [Country] {
        expression
    }
}

@CountryBuilder var list: [Country] {
    Country(name: "한국")
    Country(name: "일본")
    Country(name: "미국")
    Country(name: "중국")
    
    [
        Country(name: "호주"),
        Country(name: "영국"),
        Country(name: "홍콩")
    ]
}

// list.append(Country(name: "캐나다")) 오류 발생

print(list)

/// ViewBuilder
/// - 여러 상태 값에 따라서 여러 뷰를 반환하고 싶을 때 사용
/// -> 클로저에 childView를 구상하거나 View를 나열할 때 주로 사용
///
/// some View는 기본적으로 하나의 view만 반환할 수 있음
/// - AnyView를 통해 모든 View를 내보낼 수는 있지만 SwiftUI의 내부 구조를 알 수 없기에 권장되지 않음
/// -> ViewBuilder를 사용하면 여러개의 View를 한번에 리턴, 나열할 수 있게 됨
/// -> ViewBuilder가 ResultBuiler를 준수하기 때문
///
/// 사용자 정의 View에서도 내부 View는 클로저로 전달받아야 하며, 이때 @ViewBuilder를 준수해야함

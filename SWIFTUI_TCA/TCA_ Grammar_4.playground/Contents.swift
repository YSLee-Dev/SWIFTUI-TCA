import SwiftUI

/// TCA에서 비동기를 처리하는 방법
/// - TCA에서는 Swift Concurrency를 이용하여 비동기 처리를 진행함
/// - Combine도 비동기 처리를 할 수는 있지만, 데이터 흐름에 반응에 반응하게 됨
/// -> Swift Concurrency는 작업 자체를 비동기 처리가 가능
///
/// Swift Concurrency 이전의 비동기 처리
/// 1. Thread
/// - 오브젝트C에서는 Thread를 통해 비동기 작업을 지원함
/// - 개발자는 어떤 작업을 어떤 스레드에서 실행할지 직접 결정해야 했었으며, 클로저를 통해 작업을 호출함
/// - Thread는 다른 Thread의 작업이 언제 끝나는지 알 수 없었으며, 무한대의 Thread를 생성할 수 있었음
/// - Thread는 Non-Blocking을 지원하지 않기 때문에 CPU의 경쟁을 일으킬 수 있었음
///
/// Non-Blocking?
/// - 특정 작업이나 함수 호출이 다른 작업의 진행을 막지 않는 걸 의미
///
/// 2. Disaptch Queue
/// - Disaptch Queue는 Thread와 달리 Queue 방식으로 개발됨
/// - Queue 자체는 순차적이며, 동시성으로 작업하고 싶은 경우 attributes를 변경해야함
/// - Thread와 알리 Non-Blocking 방식으로 개발이 가능하였고, 개발자가 스레드의 개수나, 죽어있는 스레드의 개입을 피할 수 있게 됨
/// - 또한 Dispatch Group 등으로 서로 다른 Queue를 하나의 Group에서 관리할 수 있게됨
///
/// 하지만
/// - GCD 또한 각 스레드가 data race를 유발할 가능성이 남아있고, 무한대의 Thread를 생성 할 수도 있었음
///
/// 3. Swift Concurrency
/// - 2021년 wwdc에서 공개된 방식으로, async, await 키워드로 Concurrency 코드를 작성할 수 있게됨
/// - async은 함수를 정의할 때, 이 함수가 동시성 맥락을 가지고 있음을 알림
/// - await는 async으로 정의된 함수를 호출할 때 사용되며, 중간에 일시정지 될 수 있다는 걸 컴파일러/개발자에게 알림
/// - async/await가 도입되면서 개발자가 스레드의 제어권을 개입하지 않아도 됨
///
/// 일시정지?
/// - async메서드가 await와 함께 호출된 경우 해당 시점에서 일시정지 될 수 있다는 걸 의미
/// - 일시정지된 경우 해당 함수는 스레드 제어권을 시스템에 돌려줌으로, 시스템은 정지된 시간동안 다른 작업을 수행할 수 있게 됨
/// - async/await는 비동기 실행을 가능하게 했지만, 동시성 작업을 가능하게 하지는 않음
/// - 동시성 작업을 가능하게 하려면 "Task"를 사용해야 함
///
/// Task
/// - Swift가 코드를 병렬적으로 실행하는 메커니즘
/// - Task는 다른 Task와 함께 concurrent에 실행할 수 있는 비동기 컨텍스트를 제공
/// -> 비동기 처리를 위한 새로운 스레드를 할당함
/// - 백그라운드 스레드에서 즉시 실행되며, 우선순위를 변경할 수도 있음
/// - Task는 내부에서 Thread의 생성 개수를 내부적으로 제한하고 있음
/// - DispatchGroup과 동일하게 TaskGroup을 통해 Task를 하나의 Group에서 관리할 수도 있음
/// -> async-let을 통해서도 가능
///

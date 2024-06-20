import Foundation

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

print("1. START")
Thread.detachNewThread {
    print("Thread를 이용한 비동기 처리")
}
print("1. END")

print("\n")

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

print("2. START")
let queue = DispatchQueue(label: "GCD", attributes: .concurrent)

queue.sync {
    Thread.sleep(forTimeInterval: 0.3)
    print("GCD를 통한 비동기 처리1")
}

queue.async {
    Thread.sleep(forTimeInterval: 0.1)
    print("GCD를 통한 비동기 처리2")
}

queue.sync {
    print("GCD를 통한 비동기 처리3")
}

print("2. END")
Thread.sleep(forTimeInterval: 0.5)
print("\n")

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
/// - 단, Task도 Data Race가 발생할 수 있음
///
/// Data Race?
/// - 여러 스레드가 동시에 자원에 접근할 떄, 특정 스레드가 해당 자원을 변경하면서 발생하는 문제
/// - Thread, GCD에서는 NSLock등을 통해 특정 스레드에서 접근을 배재하는 식으로 사용함
/// -> 다만, 코드의 정확도가 중요해지며, 디버그가 쉽지 않았음
///
/// Actor
/// - 각 스레드에서 동시에 접근하는 변수가 동기화 될 수 있게 함
/// - Class, Struct과 동일하게 생성자, 변수, 메서드 등을 가질 수 있음
/// - Actor를 사용하면, 어떤 데이터가 어떤 스레드에서 동시에 접근되고, 처리되는 지 명확하게 파악할 수 있음
///
/// 동작방식
/// - Actor는 자신만의 맥락을 가지기 때문에 여러 스레드에서 자원에 접근하더라도 값을 처리할 수 있음
/// - 값의 동기화 작업은 비동기적으로 이루어짐
/// - 현재 접근 중이 아닌 스레드인 경우 "일시정지" 될 수 있도록 보장함
/// -> aysnc/await에서 사용한 "일시정지"와 동일하며, 현재 접근 중이 아닌 스레드는 일시정지 상태가 되어 스레드 권한을 시스템에게 넘기게 됨
/// - Actor를 메인 스레드에서 사용하고 싶을 경우 @MainActor 키워드를 붙여서 메인 스레드에서의 동작을 보장할 수 있음
/// -> DispatchQueue.main과 상호작용이 가능함

func wait() async {
    try! await Task.sleep(for: .milliseconds(100))
    print("aync/await를 사용한 비동기 처리 3")
}

print("3. START")
print("aync/await를 사용한 비동기 처리 1")
Task {
    print("aync/await를 사용한 비동기 처리 2")
    await wait()
    print("aync/await를 사용한 비동기 처리 4")
}
print("3. END")

Thread.sleep(forTimeInterval: 0.5)

print("\n")

actor Stock {
    var count = 0
    init(count: Int = 0) {
        self.count = count
    }
    
    func decrementCount() async {
        count -= 1
    }
    
    func incrementCount() async {
        count += 1
    }
}

var apple = Stock(count: 5)

Task {
    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            await apple.decrementCount()
            await print("현재 남은 사과의 개수 1", apple.count)
        }
        
        group.addTask {
            await apple.decrementCount()
            await apple.decrementCount()
            await apple.decrementCount()
            await apple.decrementCount()
            await apple.decrementCount()
            await print("현재 남은 사과의 개수 2", apple.count)
        }
        
        await group.waitForAll()
    }
}

Task {
    await apple.incrementCount()
    await print("현재 남은 사과의 개수 3", apple.count)
}

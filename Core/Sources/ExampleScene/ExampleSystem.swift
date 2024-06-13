public struct ExampleState {
    var currentValue: Int
}

public extension ExampleState {
    static var initValue: Self {
        .init(currentValue: 42)
    }
}

public enum ExampleEvent {
    case increase
    case decrease
}

public enum ExampleEffect {
    case newValue(Int)
}

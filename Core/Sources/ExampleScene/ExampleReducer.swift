public enum ExampleReducer {
    
    public static func transform(
        state: ExampleState,
        event: ExampleEvent,
        env: ExampleEnvironment
    ) async -> ExampleEffect {
        switch event {
        case .increase:
            let newValue = await env.increment(state.currentValue)
            return .newValue(newValue)
        case .decrease:
            let newValue = await env.decrement(state.currentValue)
            return .newValue(newValue)
        }
    }
    
    public static func apply(
        state: inout ExampleState,
        effect: ExampleEffect
    ) async -> ExampleState {
        switch effect {
        case .newValue(let newValue):
            state.currentValue = newValue
            return state
        }
    }
}

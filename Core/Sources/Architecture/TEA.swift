import Combine

public enum TEA {
    
    public static func start<State, Event, Effect, Environment>(
        initialState: State,
        environment: Environment,
        feedback: @escaping (AsyncStream<State>) -> AsyncStream<Event>,
        transform: @escaping (State, Event, Environment) async -> Effect,
        apply: @escaping (inout State, Effect) async -> State
    ) async {
        
        let stateSubject = CurrentValueSubject<State, Never>(initialState)
        
        let stateStream: AsyncStream<State> = AsyncStream { continuation in
            let cancellable = stateSubject.sink { continuation.yield($0) }
            continuation.onTermination = { continuation in cancellable.cancel() }
        }
        
        Task {
            var currentState = initialState
            for await event in feedback(stateStream)  {
                let newEffect = await transform(currentState, event, environment)
                currentState = await apply(&currentState, newEffect)
                stateSubject.send(currentState)
            }
        }
    }
}

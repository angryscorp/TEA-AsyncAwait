import Combine

public extension TEA {
    
    static func makeAdapter<State, Event, Effect, Environment>(
        initialState: State,
        environment: Environment,
        transform: @escaping (State, Event, Environment) async -> Effect,
        apply: @escaping (inout State, Effect) async -> State
    ) async -> ViewAdapter<State, Event> {
        let adapterSubject = PassthroughSubject<ViewAdapter<State, Event>, Never>()
        let adapterStream: AsyncStream<ViewAdapter<State, Event>> = AsyncStream { continuation in
            let cancellable = adapterSubject
                .sink(
                    receiveCompletion: { _ in continuation.finish() },
                    receiveValue: { continuation.yield($0) }
                )
            continuation.onTermination = { continuation in cancellable.cancel() }
        }
        
        await TEA.start(
            initialState: initialState,
            environment: environment,
            feedback: { stateStream in
                let adapter = ViewAdapter<State, Event>(initialState, stream: stateStream)
                adapterSubject.send(adapter)
                adapterSubject.send(completion: .finished)
                return adapter.eventStream
            },
            transform: transform,
            apply: apply
        )
        
        var iterator = adapterStream.makeAsyncIterator()
        guard let viewAdapter = await iterator.next() else {
            fatalError("Unexpected internal error")
        }
        return viewAdapter
    }
}

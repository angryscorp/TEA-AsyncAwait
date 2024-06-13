import Combine
import Foundation

public class ViewAdapter<State, Event>: ObservableObject {
    
    @Published public var state: State
    
    public lazy var eventStream: AsyncStream<Event> = AsyncStream { continuation in
        let cancellable = eventSubject.sink { continuation.yield($0) }
        continuation.onTermination = { continuation in cancellable.cancel() }
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var subscription: AnyCancellable?
    
    public init(_ initValue: State, stream: AsyncStream<State>) {
        self.state = initValue
        Task {
            for try await value in stream {
                DispatchQueue.main.async { [weak self] in
                    self?.state = value
                }
            }
        }
    }
    
    public func send(event: Event) {
        eventSubject.send(event)
    }
}

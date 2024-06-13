import Architecture
import SwiftUI

public struct ExampleView: View {
    
    @ObservedObject private var adapter: ViewAdapter<ExampleState, ExampleEvent>
    
    public init(adapter: ViewAdapter<ExampleState, ExampleEvent>) {
        self.adapter = adapter
    }
    
    public var body: some View {
        Text("Current value: \(adapter.state.currentValue)")
        HStack {
            Button("Increase", action: { adapter.send(event: .increase) }).padding()
            Button("Decrease", action: { adapter.send(event: .decrease) }).padding()
        }
    }
}

import Architecture
import ExampleScene
import SwiftUI

@main
struct DemoAppApp: App {

    @State private var exampleView: AnyView?
    
    var body: some Scene {
        WindowGroup {
            if let exampleView {
                exampleView
            } else {
               Text("Loading...")
                    .task {
                        exampleView = AnyView(await makeExample())
                    }
            }
        }
    }
}

private func makeExample() async -> some View {
    let viewAdapter = await TEA.makeAdapter(
        initialState: ExampleState.initValue,
        environment: ExampleEnvironment(
            increment: { $0 + 1 },
            decrement: { $0 - 1 }
        ),
        transform: ExampleReducer.transform,
        apply: ExampleReducer.apply
    )
        
    return await ExampleView(adapter: viewAdapter)
}

public struct ExampleEnvironment {
    
    let increment: (Int) async -> Int
    let decrement: (Int) async -> Int
    
    public init(
        increment: @escaping (Int) async -> Int,
        decrement: @escaping (Int) async -> Int
    ) {
        self.increment = increment
        self.decrement = decrement
    }
}

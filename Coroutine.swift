import Dispatch

private let coroutineQueue = DispatchQueue(label: "coroutine",
                                           qos: DispatchQoS.default,
                                           attributes: DispatchQueue.Attributes.concurrent,
                                           autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                           target: nil)

public class Coroutine<Element>: IteratorProtocol {
    private let callerReady = DispatchSemaphore(value: 0)
    private let coroutineReady = DispatchSemaphore(value: 0)
    private var done: Bool = false
    private var transportStorage: Element?
    
    public typealias Yield = (Element) -> ()
    public init(implementation: @escaping (Yield) -> ()) {
        
        coroutineQueue.async {
            // Don't start coroutine until first call.
            _ = self.callerReady.wait(timeout: DispatchTime(uptimeNanoseconds: UInt64.max))
            
            implementation { next in
                // Place element in transport storage, and let caller know it's ready.
                self.transportStorage = next
                self.coroutineReady.signal()
                
                // Don't continue coroutine until next call.
                _ = self.callerReady.wait(timeout: DispatchTime(uptimeNanoseconds: UInt64.max))
            }
            
            // The coroutine is forever over, so let's let the caller know.
            self.done = true
            self.coroutineReady.signal()
        }
    }
    
    public func next() -> Element? {
        // Make sure work is happening before we wait.
        guard !done else { return nil }
        
        // Return to the coroutine.
        callerReady.signal()
								
        // Wait until it has finished, then return and clear the result.
        _ = coroutineReady.wait(timeout: DispatchTime(uptimeNanoseconds: UInt64.max))
        defer { transportStorage = nil }
        return transportStorage
    }
}

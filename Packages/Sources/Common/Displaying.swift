import UIKit
/// A protocol for objects that can update their layout on the main thread.
public protocol Displaying {
    /// Verify the current thread to make sure the task is always executed on the main thread.
    /// - Parameter task: A task that updates the layout.
    func updateLayout(_ task: @escaping () -> Void)
}

public extension Displaying {
    func updateLayout(_ task: @escaping () -> Void) {
        guard !Thread.isMainThread else { return task() }
        DispatchQueue.main.async(execute: task)
    }
}

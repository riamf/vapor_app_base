import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    let sampleIndex = SampleIndex()
    try router.register(collection: sampleIndex)
}

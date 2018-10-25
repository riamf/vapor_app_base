import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    let sampleIndex = SampleIndex()
    let basicAuthRouter = BasicAuthRouter()
    try router.register(collection: sampleIndex)
    try router.register(collection: basicAuthRouter)
}

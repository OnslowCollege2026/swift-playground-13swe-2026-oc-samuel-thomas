// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB
@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connectoin succesful")
        } catch {
            print(error)
        }
    }
}

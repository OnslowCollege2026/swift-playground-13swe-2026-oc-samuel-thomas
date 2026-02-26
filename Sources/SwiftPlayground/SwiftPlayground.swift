// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct student: Identifiable {
    let id: Int
    var name: String
    var age: Int
}

struct Course: CustomStringConvertible {
    let id: Int
    var title: String

    var courseDescription: String{
        return "Course: \(title) - \(id)"
    }
}

@main
struct SwiftPlayground {
    static func main() {
    }
}

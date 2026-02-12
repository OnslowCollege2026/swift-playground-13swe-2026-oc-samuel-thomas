// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let passingScore = 50
        let scores = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]
        let curved = scores.map { $0 + 5}
        .filter {$0 >= passingScore}
        let average = curved.reduce(0) { $0 + $1 } / curved.count
        print(average)
    }
}

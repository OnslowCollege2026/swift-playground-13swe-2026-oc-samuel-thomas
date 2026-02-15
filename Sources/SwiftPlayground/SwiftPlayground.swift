// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let passingScore = 50
        let scores = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]

        // curve the scores by adding 5 points to each score, then filter out the scores that are below the passing score, and finally calculate the average of the curved scores
        let curved = scores.map { $0 + 5}
        .filter {$0 >= passingScore}
        let average = curved.reduce(0) { $0 + $1 } / curved.count
        print(average)
    }
}

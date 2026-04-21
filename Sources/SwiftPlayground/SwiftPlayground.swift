// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
@main
struct SwiftPlayground {
    static func main() {
        let list = [3, 7, 8, 18]
        let sum = list.reduce(0) { $0 + $1 }
        print(sum)
        let oddNumbers = list.filter { $0 % 2 != 0 }
        print(oddNumbers)
        let highestValue = list.reduce(0) {Swift.max($0, $1)}
        print(highestValue)
        let below15 = list.filter {$0 < 15}
        print(below15)
        let roundedUp = list.map 
        print(roundedUp)

    }
}

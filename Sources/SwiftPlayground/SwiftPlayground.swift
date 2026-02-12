// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let numbers = [1, 2, 3, 4, 5]

        // map
        // find the cube of each number.
        let cubedNumbers = numbers.map { number in
            return number * number * number
        }
        print(cubedNumbers)  // Output: [1, 8, 27, 64, 125]

        // filter
        // filter out the even numbers from the cubed numbers.
        let evenNumbers = cubedNumbers.filter { number in
            return number % 2 == 0
        }
        print(evenNumbers)  // Output: [8, 64]

        // reduce
        // sum up the even numbers.
        let result = evenNumbers.reduce(0) { result, item in
            return result + item
        }
        print(result)  // Output: 72

        // combined
        let total = numbers.map { number in
            return number * number * number
        }.filter { number in
            return number % 2 == 0
        }.reduce(0) { result, item in
            return result + item
        }
        print(total)  // Output: 72

        // combined better
        let totalBetter = numbers
        .map { $0 * $0 * $0 }
        .filter { $0 % 2 == 0 }
        .reduce(0, +)

        print(totalBetter)  // Output: 72
    }
}

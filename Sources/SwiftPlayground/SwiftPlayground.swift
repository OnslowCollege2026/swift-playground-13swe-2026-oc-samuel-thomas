// The Swift Programming Language
// https://docs.swift.org/swift-book


func totalCost(prices: [Double]) -> Double {
    var totalCost: Double = 0.0
    for price in prices {
        totalCost += price
        }
    return totalCost
}

func isOverBudget(total: Double, budget: Double) -> Bool{
    return total > budget
}  

func averageCost(prices: [Double]) -> Double {
    return totalCost(prices: prices) / Double(prices.count)
}

@main
struct SwiftPlayground {
    static func main() {
        let lunches = [6.50, 8.00, 5.75, 9.20, 7.10]
        var day:Int = 1
        for price in lunches {
            print("Day \(day): $\(price)")
            day += 1
        }
        print(totalCost(prices: lunches))
        print(averageCost(prices: lunches))

        let budget: Double = 35.00
    }
}

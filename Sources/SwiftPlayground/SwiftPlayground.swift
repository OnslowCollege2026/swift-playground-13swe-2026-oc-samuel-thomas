// The Swift Programming Language
// https://docs.swift.org/swift-book

// book struct holds author title and length of book plus a ethod to print a book summary
struct Book {
    var title: String
    var author: String
    var pages: Int

    func bookSummary() -> String {
        return """
            \(title) by \(author) has \(pages) pages.
            """
    }
}
// open function to print a book summary without creating an instance
func summary(title: String, author: String, pages: Int) -> String {
    return """
        \(title) by \(author) has \(pages) pages.
        """
}
// contains 2 static functions that cnonvert farenheit into celsius or celsius into farenheit
struct Temperature {

    static func toFahrenheit(celsius: Double) -> Double {
        return (celsius * 9 / 5) + 32
    }
    static func toCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }
}
// timer struct contains 2 properteis and 3 methods to start the timer, tick the timer and reset the timer
struct Timer {
    var seconds: Double
    var isRunning: Bool

    mutating func start() {
        isRunning = true
    }
    mutating func tick() {
        if isRunning == true {
            seconds += 1
        }
    }
    mutating func reset() {
        seconds = 0
        isRunning = false
    }
}
// cart struct contains 2 properties and 3 methods to add an item to the cart, check if the cart qualifies for free shipping and to print a message about free shipping
struct Cart {
    var itemsCount: Int

    static let freeShippingThreshold = 5
    mutating func addItem() {
        itemsCount += 1
    }
    static func qualifiesForFreeShipping(count: Int) -> Bool {
        if count >= Cart.freeShippingThreshold {
            return true
        } else {
            return false
        }
    }
    func shippingMessage() -> String {
        if itemsCount >= Cart.freeShippingThreshold {
            return "you are eligable for free shipping"
        } else {
            return
                "You have \(itemsCount) items, you need \(Cart.freeShippingThreshold) to be eligable for free shipping."
        }

    }
}
// stuct badge contains 2 properties and a computed property to print the name and level of the badge in a specific format
struct Badge {
    var name: String
    var level: Int

    // out comes are identical as a computed value and as a function
    var label: String {
        return "\(name) - Level \(level)"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        // declears two constants using the struct to store information of two books
        let book1 = Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", pages: 180)
        let book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", pages: 281)
        // Book task, prints out book summaries using open function
        print(summary(title: book1.title, author: book1.author, pages: book1.pages))
        print(summary(title: book2.title, author: book2.author, pages: book2.pages))
        // prints out temperature conversions using the static functions in the Temperature struct passing in values for temp
        print(Temperature.toFahrenheit(celsius: 22))
        print(Temperature.toCelsius(fahrenheit: 65))
        print(Temperature.toCelsius(fahrenheit: 120))

        // timer task, creates an instance of the timer struct and calls the start, tick and reset functions to show how the seconds property changes with each function call
        var timer = Timer(seconds: 0, isRunning: false)
        timer.start()
        print(timer.seconds)
        timer.tick()
        print(timer.seconds)
        timer.reset()
        print(timer.seconds)
        // cart task, creates an instance of the cart struct and uses a while loop to add items to the cart and print out the shipping message after each item is added to show how the message changes as the items count increases
        var amountofcycles = 0
        var cart1 = Cart(itemsCount: 0)
        while amountofcycles < 6 {
            cart1.addItem()

            amountofcycles += 1
            print(cart1)
            // data is stored in the cart1 vairable so we can call the shippingMessage function to check if we are eligable for free shipping
            print(cart1.shippingMessage())

        }
        // badge task, creates a constant using the struct to stor information about a badge and then prints out the summary using the label method from the struct.
        let badge1 = Badge(name: "sheriff", level: 3)
        print(badge1.label)

    }

}

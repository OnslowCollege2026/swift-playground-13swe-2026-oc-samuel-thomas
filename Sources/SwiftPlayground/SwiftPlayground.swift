// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Student {
    let id: Int
    var name: String
    var age: Int
    let nsn: Int
    var email: String

    func summary() -> String {
        return """
            ID: \(id)
            Name: \(name)
            Age: \(age)
            NSN: \(nsn)
            Email: \(email)
            """
    }
}

struct Car {
    let brand: String
    let model: String
    let year: Int
    func summary() -> String {
        return """
            Brand: \(brand)
            Model: \(model)
            Year: \(year)
            """
    }
}

struct BankAccount {
    let owner: String
    var balance: Double

    func description() -> String {
        return """
            Owner: \(owner)
            Balance: $\(balance)
            """
    }
}

struct Rectangle {
    var width: Double
    var height: Double

    func area() -> Double {
        return width * height
    }
}

struct Quest {
    var title: String
    var difficulty: String
    var reward: Int

    
}

@main
struct SwiftPlayground {
    static func main() {
        let students = [
            Student(
                id: 12345,
                name: "Idris",
                age: 18,
                nsn: 123_456_789,
                email: "idris.elba@student.onslow.school.nz"
            ),
            Student(
                id: 54321,
                name: "Channing",
                age: 17,
                nsn: 987_654_321,
                email: "channing.tatum@onslow.school.nz"
            ),
            Student(
                id: 54123,
                name: "Hugh",
                age: 16,
                nsn: 321_654_987,
                email: "hugh.jackman@student.onslow.school.nz"
            ),
            Student(
                id: 32145,
                name: "Jennifer",
                age: 18,
                nsn: 213_546_879,
                email: "jennifer.lawrence@student.onslow.school.nz"
            ),
            Student(
                id: 45213,
                name: "Britney",
                age: 15,
                nsn: 789_645_312,
                email: "britney.spears@student.onslow.school.nz"
            ),
        ]

        let sam = Student(
            id: 22361,
            name: "Sam",
            age: 16,
            nsn: 0_144_467_007,
            email: "samuel.thomas@student.onslow.school.nz"
        )

        let cars = [
            Car(
            brand: "BMW",
            model: "116i",
            year: 2012
            ),
            Car(
            brand: "Subaru",
            model: "Outback",
            year: 2025
            )
        ]

        for student in students {
            print("")
            print(student.summary())
        }

        let BankAccounts = [
            BankAccount(
                owner: "Alice",
                balance: 1500.00
            ),
            BankAccount(
                owner: "Bob",
                balance: 2500.50
            ),
        ]

        let rectangles = [
            Rectangle(
                width : 5.0,
                height: 10.0
            ),
            Rectangle(
                width: 3.5,
                height: 7.2
            )
        ]

        print("")
        print(sam.summary())

        for car in cars {
            print("")
            print(car.summary())
        }
        for account in BankAccounts {
            print("")
            print(account.description())
        }

        for rectangle in rectangles {
            print(rectangle.area())
        }
    }
}

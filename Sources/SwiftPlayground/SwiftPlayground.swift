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
        print(sam.summary())
    }
}

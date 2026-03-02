// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {
        struct book {
            var title: String
            var author: String 
            var pages: Int

            func summary() -> String {
                return "\(title) by \(author) has \(pages) pages."
            }

        }

        func bookSummary(title: String, author: String, pages: Int) -> String {
            return "\(title) by \(author) has \(pages) pages."
        }

        let book1 = book(title: "Blood Meridian", author: "Cormac McCarthy", pages: 337)
        let book2 = book(title: "Harry Potter and the half-blood prince", author: "J.K. Rowling", pages: 652)
        print(book1.summary())
        print(book2.summary())
    }
}

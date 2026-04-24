// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

struct Borrowers: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "borrowers"
    /// the borrower ID
    let id: Int
    /// borrowers name
    var name: String
    /// borrowers email
    var email: String
    /// borrowers phone number
    var phone: String

    enum CodingKeys: String, CodingKey {
        case id = "borrowerID"
        case name
        case email
        case phone

    enum Columns {
        static let id = Column("borrowersID")
        static let name = Column("name")
        static let email = Column("email")
        static let phone = Column("phone")
    }
    }
}
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "books"
    /// the book ID
    let id: Int
    /// book title
    var title: String
    /// book author
    var author: String
    /// year book was published
    let yearPublished: Int

    enum CodingKeys: String, CodingKey {
        case id = "bookID"
        case title
        case author
        case yearPublished
    }
}
struct Loans: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "loans"
    /// the loan id
    let id: Int
    /// the book id
    var bookID: Int
    /// the borrower id
    var borrowerID: Int
    /// date book was borrowed
    var dateBorrowed: String
    /// date book was returned , nullable
    var dateReturned: String?
    

    enum CodingKeys: String, CodingKey {
        case id = "loanID"
        case bookID
        case borrowerID
        case dateBorrowed
        case dateReturned
    }
}


@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/bookDatabase.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connection succesful")

            try dbQueue.read { db in
                // try db.dumpSchema()
            }

            try dbQueue.read { db in
                let borrowers = try Borrowers
                .order(Borrowers.Columns.name)
                .fetchAll(db)
                for borrower in borrowers {
                    print("borrowerID: \(borrower.id), borrowerName: \(borrower.name)")
                }
            }

        
            let bookID = 1

            try dbQueue.read { db in
                if let book = try Books.fetchOne(db, key: bookID) {
                    print("Found book with ID \(book.id): \(book.title)")
                } else {
                    print("No book with id \(bookID)")
                }
            }
            
            let loanID = 0

            try dbQueue.read { db in
                if let loan = try Loans.fetchOne(db, key: loanID) {
                    let returned = loan.dateReturned ?? "Not Returned"
                    print("Found loan with ID \(loan.id): bookID: \(loan.bookID), borrowerID: \(loan.borrowerID), date borrowed:\(loan.dateBorrowed), date returned: \(returned)")
                } else {
                    print("No loan with id \(loanID)")
                }
            }
            
        } catch {
            print(error)
        }
    }
}

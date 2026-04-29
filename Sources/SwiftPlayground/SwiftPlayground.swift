// The Swift Programming Language
// https://docs.swift.org/swift-book

// remember the Int? is unreliable do something about that

import Foundation
import GRDB

let fallbackValue: Int = -1
struct Borrowers: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "borrowers"
    /// the borrower ID
    let id: Int?
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
    }
    enum Columns {
        static let id = Column("borrowersID")
        static let name = Column("name")
        static let email = Column("email")
        static let phone = Column("phone")
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
    enum Columns {
        static let id = Column("bookID")
        static let title = Column("title")
        static let author = Column("Author")
        static let yearPublished = Column("yearPublished")
    }
}
struct Loans: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "loans"
    /// the loan id
    let id: Int?
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
    enum Columns {
        static let id = Column("loanID")
        static let bookID = Column("bookID")
        static let borrowerID = Column("borrowerID")
        static let dateBorrowed = Column("dateBorrowed")
        static let dateReturned = Column("dateReturned")
    }
}

func showMenu() {
    print("Choose an option:")
    print("A - View Available/Unavailable Books")
    print("B - Loan Book")
    print("C - Return Book")
    print("D - Search Book")
    print("E - Add new Book")
    print("F - Edit Book Records")
    print("G - Register new Borrower")
    print("H - Search Borrower")
    print("I - Edit Borrower Records")
}

// got from stack overflow
func currentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: Date())
}

func loanBook(bookID: Int, borrowerID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            // find borrower with id
            if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower with ID \(borrower.id ?? fallbackValue): \(borrower.name)")
            } else {
                print("No borrower found with id \(borrowerID)")
                return
            }
            // find book with id
            if let book = try Books.fetchOne(db, key: bookID) {
                print("Found book with ID \(book.id): \(book.title)")
            } else {
                print("No book with id \(bookID)")
                return
            }
            let alreadyLoaned =
                try Loans
                .filter(Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil)
                .fetchOne(db)

            if alreadyLoaned != nil {
                print("book already loaned")
                return
            }

            let newLoan = Loans(
                id: nil,
                bookID: bookID,
                borrowerID: borrowerID,
                dateBorrowed: currentDate(),
                dateReturned: nil
            )
            try newLoan.insert(db)
            print("Loan made correctly")

        }
    } catch {
        print("error")
    }
}


@main
struct SwiftPlayground {
    static func main() {
        print(currentDate())
        let dbpath = "Sources/SwiftPlayground/bookDatabase.db"
        
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connection succesful")
            loanBook(bookID: 1, borrowerID: 1, dbQueue: dbQueue)
        /*
            let borrowerID = 3
        
            try dbQueue.write { db in
                if var borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                    print(
                        "Found borrower with ID \(borrower.id ?? fallbackValue): \(borrower.name)")
                    borrower.name = "Bradley Pitt"
                    try borrower.update(db)
                    print("New name is \(borrower.name)")
                } else {
                    print("No borrower with id \(borrowerID)")
                }
            }
        
            try dbQueue.write { db in
                let newBorrower = Borrowers(
                    id: nil, name: "Brad Pitt", email: "brad.pitt@gmail.com", phone: "021123987")
                try newBorrower.insert(db)
            }
            try dbQueue.read { db in
                let borrowers =
                    try Borrowers
                    .order(Borrowers.Columns.name)
                    .fetchAll(db)
                for borrower in borrowers {
                    print(
                        "borrowerID: \(borrower.id ?? fallbackValue), borrowerName: \(borrower.name)"
                    )
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
                    print(
                        "Found loan with ID \(loan.id): bookID: \(loan.bookID), borrowerID: \(loan.borrowerID), date borrowed:\(loan.dateBorrowed), date returned: \(returned)"
                    )
                } else {
                    print("No loan with id \(loanID)")
                }
            }
        */
        } catch {
            print(error)
        }
        
    }
}

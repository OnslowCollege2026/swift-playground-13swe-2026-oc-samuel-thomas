// The Swift Programming Language
// https://docs.swift.org/swift-book





// remember to change the test types in testing
// remember to add documentation throughout
// make sure things that shouldnt be null or should be unique are.







import Foundation
import GRDB

// fallback value for missing IDs
let fallbackValue: Int = -1


/// Represents a borrwer in the library.
///
/// A borrower is someone who can loan books from the library/
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

    func summary() -> String {
        return "ID: \(formatID(id: id)) | Name: \(name) | Email: \(email) | Phone: \(phone)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "borrowerID"
        case name
        case email
        case phone
    }
    enum Columns {
        static let id = Column("borrowerID")
        static let name = Column("name")
        static let email = Column("email")
        static let phone = Column("phone")
    }
}
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "books"
    /// the book ID
    let id: Int?
    /// book title
    var title: String
    /// book author
    var author: String
    /// year book was published
    var yearPublished: Int

    func summary() -> String {
        return
            "ID: \(formatID(id: id)) | Title: \(title) | Author: \(author) | Year Published: \(yearPublished)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "bookID"
        case title
        case author
        case yearPublished
    }
    enum Columns {
        static let id = Column("bookID")
        static let title = Column("title")
        static let author = Column("author")
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

    func summary() -> String {
        return
            "ID: \(formatID(id: id)) | Book ID: \(bookID) | Borrower ID: \(borrowerID) | Date Borrowed: \(dateBorrowed) | Date Returned: \(dateReturned ?? "N/A")"
    }

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
    print(
        """
        Choose an option:
        1 - Search Book
        2 - Loan Book
        3 - Return Book
        4 - Add new Book
        5 - Delete Book
        6 - Edit Book Records
        7 - Search Borrower
        8 - Register new Borrower
        9 - Delete Borrower
        10 - Edit Borrower Records
        0 - Exit
        """)
}
func formatID(id: Int?) -> String {
    if let id = id {
        return "\(id)"
    } else {
        return "N/A"
    }

}

func currentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: Date())
}

func loanBook(dbQueue: DatabaseQueue) {
    print("enter book ID: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue

    print("enter borrower ID: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            print("")
            // find borrower with id
            if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower: \(borrower.summary())")
            } else {
                print("No borrower found with id \(borrowerID)")
                return
            }
            // find book with id
            if let book = try Books.fetchOne(db, key: bookID) {
                print("Found book: \(book.summary()) ")
            } else {
                print("No book found with id \(bookID)")
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

func returnBook(dbQueue: DatabaseQueue) {
        print("enter book id to return: ")
        let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            if var loan = try Loans
                .filter(
                    Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil
                    )
                .fetchOne(db){
                let borrower = try Borrowers.fetchOne(db, key: loan.borrowerID)
                let book = try Books.fetchOne(db, key: loan.bookID)
                print(
                    "Found loan: ID: \(formatID(id: loan.id)) | Book ID: \(formatID(id: book?.id)) | Book Title: \(book?.title ?? "Unknown") | Borrower ID: \(formatID(id: borrower?.id)) | Borrower Name: \(borrower?.name ?? "Unknown") | Date Borrowed: \(loan.dateBorrowed) | Date Returned: \(loan.dateReturned ?? "N/A")"
                )
                if loan.dateReturned != nil {
                    print("book already returned")
                    return
                }
                loan.dateReturned = currentDate()
                try loan.update(db)

                print("book returned")

            } else {
                print("No current loan found with book id \(bookID)")
                return
            }
        }
    } catch {
        print("error")
    }
}

func searchBook(dbQueue: DatabaseQueue) {
    print("enter book or author name ")
    print("or enter nothing and view all books:  ")
    let bookSearch = readLine() ?? ""
    do {
        try dbQueue.read { db in
            let books = try Books.fetchAll(db)
            var bookFound = false
            for book in books {
                if bookSearch == "" {
                    print(book.summary())
                    bookFound = true
                }
                if book.title.lowercased().contains(bookSearch.lowercased())
                    || book.author.lowercased().contains(bookSearch.lowercased())
                {
                    let onLoan =
                        try Loans
                        .filter(
                            Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil
                        )
                        .fetchOne(db)

                    if onLoan == nil {
                        print("\(book.summary()) | Status: Available")
                    } else {
                        print("\(book.summary()) | Status: Unavailable")
                    }
                    bookFound = true
                }
            }
            if bookFound == false {
                print("no book found")
            }
        }
    } catch {
        print("error")
    }
}

func addBook(dbQueue: DatabaseQueue) {
    print("enter book name: ")
    let bookTitle = readLine() ?? ""
    print("enter author name: ")
    let bookAuthor = readLine() ?? ""
    print("enter year published: ")
    let bookYearPublished = Int(readLine() ?? "") ?? fallbackValue
                    
    do {
        try dbQueue.write { db in
            let newBook = Books(
                id: nil, title: bookTitle, author: bookAuthor, yearPublished: bookYearPublished)
            if newBook.title == "" {
                print("please enter a book title")
                return
            }
            if newBook.author == "" {
                print("please enter a book author")
                return
            }

            try newBook.insert(db)
            print("book succesfully added")
        }
    } catch {
        print("error")
    }
}

func deleteBook(dbQueue: DatabaseQueue) {
    print("enter book id: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            if let book = try Books.fetchOne(db, key: bookID) {
                print("Found book with \(book.summary())")
                let activeLoan =
                    try Loans
                    .filter(
                        Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil
                    )
                    .fetchOne(db)

                if activeLoan != nil {
                    print("can't delete book as book is currently on loan")
                    return
                }
                try book.delete(db)
                print("book succesfuly deleted")
            } else {
                print("No book found with id \(bookID)")
            }

        }
    } catch {
        print("error")
    }
}

func editBook(dbQueue: DatabaseQueue) {
    print("enter book id: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            if var book = try Books.fetchOne(db, key: bookID) {
                print("Found book with \(book.summary())")
                print("enter new book title or press enter to keep \(book.title)")
                if let newTitle = readLine(), newTitle != "" {
                    book.title = newTitle
                }
                print("enter new book author or press enter to keep \(book.author)")
                if let newAuthor = readLine(), newAuthor != "" {
                    book.author = newAuthor
                }
                print("enter new book year published or press enter to keep \(book.yearPublished)")
                if let newYearPublished = readLine(), newYearPublished != "" {
                    if let newYearPublished = Int(newYearPublished) {
                        book.yearPublished = newYearPublished
                    } else {
                        print("invalid year entered")
                    }
                }
                try book.update(db)
                print("book succesfully updated")
                print(book.summary())
            } else {
                print("No book with id \(bookID)")
            }
        }
    } catch {
        print("error")
    }
}

func addBorrower(dbQueue: DatabaseQueue) {
    print("enter borrower name: ")
    let borrowerName = readLine() ?? ""
    print("enter borrower email: ")
    let borrowerEmail = readLine() ?? ""
    print("enter borrower phone: ")
    let borrowerPhone = readLine() ?? ""
    do {
        try dbQueue.write { db in
            let newBorrower = Borrowers(
                id: nil, name: borrowerName, email: borrowerEmail, phone: borrowerPhone)
            if newBorrower.name == "" {
                print("please enter a borrower name")
                return
            }
            if newBorrower.email == "" {
                print("please enter a borrower email")
                return
            }
            if newBorrower.phone == "" {
                print("please enter a borrower phone")
                return
            }

            try newBorrower.insert(db)
            print("borrower succesfully added")
        }
    } catch {
        print("error")
    }
}

func searchBorrower(dbQueue: DatabaseQueue) {
        print("enter borrower name:")
        let borrowerSearch = readLine() ?? ""
    do {
        try dbQueue.read { db in
            let borrowers = try Borrowers.fetchAll(db)
            var borrowerFound = false

            for borrower in borrowers {
                if borrower.name.lowercased().contains(borrowerSearch.lowercased()) {
                    print(borrower.summary())
                    let onLoan =
                        try Loans
                        .filter(
                            Loans.Columns.borrowerID == borrower.id
                                && Loans.Columns.dateReturned == nil
                        )
                        .fetchAll(db)
                        if onLoan.isEmpty {
                            print("current loans: none")
                        } else {
                            print("current loans: ")
                            for loan in onLoan {
                                if let book = try Books.fetchOne(db, key: loan.bookID) {
                                    print(book.summary())
                                }
                            }
                        }

                    
                    borrowerFound = true
                    
                }
            }
            if borrowerFound == false {
                print("no borrower found")
            }
        }
    } catch {
        print("error")
    }
}

func editBorrower(dbQueue: DatabaseQueue) {
    print("enter borrower id: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            if var borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower with \(borrower.summary())")
                print("enter new borrower name or press enter to keep \(borrower.name)")
                if let newName = readLine(), newName != "" {
                    borrower.name = newName
                }
                print("enter new borrower email or press enter to keep \(borrower.email)")
                if let newEmail = readLine(), newEmail != "" {
                    borrower.email = newEmail
                }
                print("enter new borrower phone number or press enter to keep \(borrower.phone)")
                if let newPhone = readLine(), newPhone != "" {
                    borrower.phone = newPhone
                }
                try borrower.update(db)
                print("borrower succesfully updated")
                print(borrower.summary())
            } else {
                print("No borrower with id \(borrowerID)")
            }
        }

    } catch {
        print("error")
    }
}

func deleteBorrower(dbQueue: DatabaseQueue) {
    print("enter borrower id: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower with \(borrower.summary())")
                let activeLoan =
                    try Loans
                    .filter(
                        Loans.Columns.borrowerID == borrowerID && Loans.Columns.dateReturned == nil
                    )
                    .fetchOne(db)

                if activeLoan != nil {
                    print("can't delete borrower as borrower has books loaned")
                    return
                }
                try borrower.delete(db)
                print("borrower succesfuly deleted")
            } else {
                print("No borrower with id \(borrowerID)")
            }
        }
    } catch {
        print("error")
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/bookDatabase.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connection succesful")
            var running = true
            while running {
                showMenu()
                let option = readLine()
                switch option?.uppercased() {

                case "1":
                    searchBook(dbQueue: dbQueue)
                case "2":
                    loanBook(dbQueue: dbQueue)
                case "3":
                    returnBook(dbQueue: dbQueue)
                case "4":
                    addBook(dbQueue: dbQueue)
                case "5":
                    deleteBook(dbQueue: dbQueue)
                case "6":
                    editBook(dbQueue: dbQueue)
                case "7":
                    searchBorrower(dbQueue: dbQueue)
                case "8":
                    addBorrower(dbQueue: dbQueue)
                case "9":
                    deleteBorrower(dbQueue: dbQueue)
                case "10":
                    editBorrower(dbQueue: dbQueue)
                case "0":
                    running = false
                    print("goodbye")

                default:
                    print("??")
                }
                if running {
                    print("press enter to continue")
                    _ = readLine()
                }

            }
        } catch {
            print(error)
        }

    }
}

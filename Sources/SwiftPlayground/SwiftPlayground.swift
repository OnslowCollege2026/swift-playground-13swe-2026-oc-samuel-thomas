// The Swift Programming Language
// https://docs.swift.org/swift-book

// remember to change the test types in testing
// remember to add documentation throughout
// make sure things that shouldnt be null or should be unique are.

import Foundation
import GRDB

// Fallback value for missing IDs.
let fallbackValue: Int = -1

/// Represents a borrwer in the library.
///
/// A borrower is someone who can loan books from the library.
/// Each borrower has id and contact information stored in the database.
struct Borrowers: Identifiable, Codable, FetchableRecord, PersistableRecord {

    /// Name of the table in the database that stores borrower information.
    static let databaseTableName = "borrowers"

    /// The borrower ID.
    let id: Int?

    /// Borrowers name.
    var name: String

    /// Borrowers email.
    var email: String

    /// Borrowers phone number.
    var phone: String

    /// Returns a summary of borrower information.
    /// 
    /// - Returns: A string containing a summary of borrower information including Id, Name, Email, and Phone.
    func summary() -> String {
        return "ID: \(formatID(id: id)) | Name: \(name) | Email: \(email) | Phone: \(phone)"
    }

    /// Keys used for coding to and from the database.
    enum CodingKeys: String, CodingKey {
        case id = "borrowerID"
        case name
        case email
        case phone
    }

    /// Column names used for connecting with the database.
    enum Columns {
        static let id = Column("borrowerID")
        static let name = Column("name")
        static let email = Column("email")
        static let phone = Column("phone")
    }
}

/// Represents a book in the library.
///
/// A book is something that can be loaned by a borrower. 
/// Each book has an id and information stored in the database.
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord {

    /// Name of the table in the database that stores book information.
    static let databaseTableName = "books"

    /// The book ID.
    let id: Int?

    /// The book title.
    var title: String

    /// The book author.
    var author: String

    /// The year the book was published.
    var yearPublished: Int

    /// Returns a summary of book information.
    /// 
    /// - Returns: A string containing a summary of book information including Id, Title, Author, and Year Published.
    func summary() -> String {
        return
            "ID: \(formatID(id: id)) | Title: \(title) | Author: \(author) | Year Published: \(yearPublished)"
    }

    /// Keys used for coding to and from the database.
    enum CodingKeys: String, CodingKey {
        case id = "bookID"
        case title
        case author
        case yearPublished
    }

    /// Column names used for connecting with the database.
    enum Columns {
        static let id = Column("bookID")
        static let title = Column("title")
        static let author = Column("author")
        static let yearPublished = Column("yearPublished")
    }
}

/// Represents a loan in the library.
///
/// A loan links a borrower to a book for some time.
/// Each loan has an id and information stored in the database.
struct Loans: Identifiable, Codable, FetchableRecord, PersistableRecord {

    /// Name of the table in the database that stores loan information.
    static let databaseTableName = "loans"

    /// The loan id.
    let id: Int?

    /// The book id.
    var bookID: Int

    /// The borrower id.
    var borrowerID: Int

    /// The date the book was borrowed.
    var dateBorrowed: String

    /// The date the book was returned , nullable.
    var dateReturned: String?

    /// Keys used for coding to and from the database.
    enum CodingKeys: String, CodingKey {
        case id = "loanID"
        case bookID
        case borrowerID
        case dateBorrowed
        case dateReturned
    }

    /// Column names used for connecting with the database.
    enum Columns {
        static let id = Column("loanID")
        static let bookID = Column("bookID")
        static let borrowerID = Column("borrowerID")
        static let dateBorrowed = Column("dateBorrowed")
        static let dateReturned = Column("dateReturned")
    }
}

/// Displays the menu options.
/// 
/// This function prints all options the user can choice to do.
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

/// converts an optional integer id  into a string.
/// 
/// If the id is nil, returns "N/A". If not it prints id as a string.
/// 
/// - Parameter:
///     - id: the optional integer.
/// - Returns: A string for id or "N/A".
func formatID(id: Int?) -> String {
    if let id = id {
        return "\(id)"
    } else {
        return "N/A"
    }
}

/// Returns the current date as a string formatted in dd/MM/yyyy.
/// 
/// - Returns: A string with the current data.
func currentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: Date())
}

/// Loans a book to a borrower if both exist and book is not already on loan.
/// 
/// Prompts for book and borrower Id.
/// Checks if both exist.
/// Makes sure book is not already loaned out.
/// Creates and inserts a new loan record with current date to database.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Returns a book borrowed by a borrower by changing loan information.
/// 
/// Prompts for book ID.
/// Finds active loan for that book.
/// Displays loan details.
/// Edits loan by setting return date to current date.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Searches for book by title or author, or displays all books.
/// 
/// Prompts for a search.
/// Matches book by title or author.
/// If no input given, displays all books in library.
/// Shows book information and wether or not it is on loan.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Adds a new book to database.
/// 
/// Prompts for book title, author, and year published.
/// Makes sure required fields are not empty
/// Creates and inserts a new book record to database.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Deletes a book from database that is currently not on loan.
/// 
/// Prompts for book id.
/// Checks if book exist.
/// Makes sure book is not already loaned out.
/// Deletes book record from database.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Edits an existing book record in database.
/// 
/// Prompts for book Id.
/// Checks if book exists.
/// Allows user to update title, author, or year published.
/// Changes nothing to field that user does not enter a value into.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Adds a new borrower to database.
/// 
/// Prompts for borrower name, email, and phone.
/// Makes sure required fields are not empty.
/// Creates and inserts a new borrower record to database.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Searches for book by name and displays their current loans.
/// 
/// Prompts for a search.
/// Matches borrower(s) by name.
/// Shows borrower information.
/// Prints all active loans for borrower(s).
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Edits an existing borrower record in database.
/// 
/// Prompts for borrower Id.
/// Checks if borrower exists.
/// Allows user to update name, email, or phone.
/// Changes nothing to field that user does not enter a value into.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

/// Deletes a borrower from database that is currently has no loans.
/// 
/// Prompts for borrower id.
/// Checks if borrower exists.
/// Makes sure borrower has no active loans
/// Deletes borrower record from database.
/// 
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
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

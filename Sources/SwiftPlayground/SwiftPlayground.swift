// The Swift Programming Language
// https://docs.swift.org/swift-book

// remember the Int? possibly unreliable and might need to do something about that
// remember the unavailable and available book functions, could be seen as repetitive
// remember to change the test types in testing
// maybe add a required amount of numbers for the phone number
// think about adding a unique factor to the email and phone, possibly not though as kids may use parents phone or email, maybe just make email unique and phone not unique?
// search book/borrower and edit book/borrower should maybe be combined idk tho.
// for search borrower be able to search by name email or phone or id similar thing with search book
// remember to add documentation throughout
// possible change things to read line
// when something is deleted then a new one is added there is gap in id, change this.
// show list of borrowers current loans or all loans
// make sure things that shouldnt be null or should be unique are.
// remember refinements
// maybe make it so books are loanes by searching them first?
// change case c
// fix all the silly stuff in the cases

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
    let id: Int?
    /// book title
    var title: String
    /// book author
    var author: String
    /// year book was published
    var yearPublished: Int

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
    print("A - View Available Books")
    print("B - View Unavailable Books")
    print("C - Loan Book")
    print("D - Return Book")
    print("E - Search Book")
    print("F - Add new Book")
    print("G - Delete Book")
    print("H - Edit Book Records")
    print("I - Register new Borrower")
    print("J - Search Borrower")
    //print("K - Delete Borrower")
    print("L - Edit Borrower Records")
    // print("M - View Current Loans")
    print("X - Exit")
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
                print("Found book with ID \(book.id ?? fallbackValue): \(book.title)")
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

func returnBook(loanID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            if var loan = try Loans.fetchOne(db, key: loanID) {
                print(
                    "Found loan with ID \(loan.id ?? fallbackValue): borrower id: \(loan.borrowerID), book id: \(loan.bookID))"
                )
                if loan.dateReturned != nil {
                    print("book already returned")
                    return
                }
                loan.dateReturned = currentDate()
                try loan.update(db)

                print("book returned")

            } else {
                print("No loan found with id \(loanID)")
                return
            }
        }
    } catch {
        print("error")
    }
}

func availableBooks(dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in
            let books = try Books.fetchAll(db)

            for book in books {
                let onLoan =
                    try Loans
                    .filter(Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil)
                    .fetchOne(db)

                if onLoan == nil {
                    print(book.id ?? fallbackValue)
                }

            }
        }
    } catch {
        print("error")
    }
}

func unavailableBooks(dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in
            let books = try Books.fetchAll(db)

            for book in books {
                let onLoan =
                    try Loans
                    .filter(Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil)
                    .fetchOne(db)

                if onLoan != nil {
                    print(book.id ?? fallbackValue)
                }

            }
        }
    } catch {
        print("error")
    }
}


func searchBook(bookSearch: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in
            let books = try Books.fetchAll(db)
            var bookFound = false

            for book in books {
                if book.title.lowercased().contains(bookSearch.lowercased()) {
                    let onLoan =
                        try Loans
                        .filter(
                            Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil
                        )
                        .fetchOne(db)

                    if onLoan == nil {
                        print("book title: \(book.title), book availability: available")
                    } else {
                        print("book title: \(book.title), book availability: unavailable")
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

func addBook(bookTitle: String, bookAuthor: String, bookYearPublished: Int, dbQueue: DatabaseQueue)
{
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

func deleteBook(bookID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            if let book = try Books.fetchOne(db, key: bookID) {
                print("Found book with ID \(book.id ?? fallbackValue): \(book.title)")
                let onLoan =
                    try Loans
                    .filter(
                        Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil
                    )
                    .fetchOne(db)

                if onLoan != nil {
                    print("can't delete book as book is currently on loan")
                    return
                }
                try book.delete(db)
                print("book succesfuly deleted")
            } else {
                print("No book with id \(bookID)")
            }

        }
    } catch {
        print("error")
    }
}

func editBook(bookID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            if var book = try Books.fetchOne(db, key: bookID) {
                print("Found book with ID \(book.id ?? fallbackValue): \(book.title)")
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
                print(
                    "id: \(book.id ?? fallbackValue) title: \(book.title), author: \(book.author), year published: \(book.yearPublished)"
                )
            } else {
                print("No book with id \(bookID)")
            }
        }
    } catch {
        print("error")
    }
}

func addBorrower(
    borrowerName: String, borrowerEmail: String, borrowerPhone: String, dbQueue: DatabaseQueue
) {
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

func searchBorrower(borrowerSearch: String, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.read { db in
            let borrowers = try Borrowers.fetchAll(db)
            var borrowerFound = false

            for borrower in borrowers {
                if borrower.name.lowercased().contains(borrowerSearch.lowercased()) {
                    print(
                        "id: \(borrower.id ?? fallbackValue), name: \(borrower.name), email: \(borrower.email), phone: \(borrower.phone)"
                    )
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

func editBorrower(borrowerID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            if var borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower with ID \(borrower.id ?? fallbackValue): \(borrower.name)")
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
                print(
                    "id: \(borrower.id ?? fallbackValue) name: \(borrower.name), email: \(borrower.email), phone: \(borrower.phone)"
                )
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
            var running  = true
            while running {
                showMenu()
                let option = readLine()
                switch option?.uppercased() {
                
                case "A":
                    availableBooks(dbQueue: dbQueue)
                case "B":
                    unavailableBooks(dbQueue: dbQueue)
                case "C":
                    print("enter book id: ")
                    let bookID = Int(readLine() ?? "") ?? fallbackValue
                    print("enter borrower id: ")
                    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
                    loanBook(bookID: bookID, borrowerID: borrowerID, dbQueue: dbQueue)
                case "D":
                    print("enter loan id: ")
                    let loanID = Int(readLine() ?? "") ?? fallbackValue
                    returnBook(loanID: loanID, dbQueue: dbQueue)
                case "E":
                    print("enter book name: ")
                    let search = readLine() ?? ""
                    searchBook(bookSearch: search, dbQueue: dbQueue)
                case "F":
                    print("enter book name: ")
                    let bookTitle = readLine() ?? ""
                    print("enter author name: ")
                    let bookAuthor = readLine() ?? ""
                    print("enter year published: ")
                    let yearPublished = Int(readLine() ?? "") ?? fallbackValue
                    addBook(bookTitle: bookTitle, bookAuthor: bookAuthor, bookYearPublished: yearPublished, dbQueue: dbQueue)
                case "G":
                    print("enter book id: ")
                    let bookID = Int(readLine() ?? "") ?? fallbackValue
                    deleteBook(bookID: bookID, dbQueue: dbQueue)
                case "H":
                    print("enter book id: ")
                    let bookID = Int(readLine() ?? "") ?? fallbackValue
                    editBook(bookID: bookID, dbQueue: dbQueue)
                case "I":
                    print("enter borrower name: ")
                    let borrowerName = readLine() ?? ""
                    print("enter borrower email: ")
                    let borrowerEmail = readLine() ?? ""
                    print("enter borrower phone: ")
                    let borrowerPhone = readLine() ?? ""
                    addBorrower(borrowerName: borrowerName, borrowerEmail: borrowerEmail, borrowerPhone: borrowerPhone, dbQueue: dbQueue)
                case "J":
                    print("enter borrower name: ")
                    let borrowerName = readLine() ?? ""
                    searchBorrower(borrowerSearch: borrowerName, dbQueue: dbQueue)
                case "K":
                print("delete borrowe not added yet")
                case "L":
                    print("enter borrower id: ")
                    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
                    editBorrower(borrowerID: borrowerID, dbQueue: dbQueue)
                case "M":
                    print("show loans not added yet")
                case "X":
                    running = false
                    print("goodbye")
                default:
                print("??")    
                }
            }
        } catch {
            print(error)
        }

    }
}

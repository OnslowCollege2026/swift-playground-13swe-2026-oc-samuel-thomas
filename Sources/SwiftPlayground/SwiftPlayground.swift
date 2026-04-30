// The Swift Programming Language
// https://docs.swift.org/swift-book

// remember the Int? is unreliable do something about that
// remember the unavailable and available book functions, could be seen as repetitive
// remember to change the test types in testing
// maybe add a required amount of numbers for the phone number
// think about adding a unique factor to the email and phone, possibly not though as kids may use parents phone or email, maybe just make email unique and phone not unique?
// search book/borrower and edit book/borrower should maybe be combined idk tho.
// for search borrower be able to search by name email or phone or id similar thing with search book


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

func exampleFunction(dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in

        }
    } catch {
        print("error")
    }
}

func showMenu() {
    print("Choose an option:")
    //    print("A - View Available Books")
    //    print("B - View Unavailable Books")
    //    print("C - Loan Book")
    //    print("D - Return Book")
    //    print("E - Search Book")
    //    print("F - Add new Book")
    print("G - Edit Book Records")
    //    print("H - Register new Borrower")
    //    print("I - Search Borrower")
    print("J - Edit Borrower Records")
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

func editBook(bookID: Int, dbQueue: DatabaseQueue) {
    do {
        try dbQueue.write { db in
            if var book = try Books.fetchOne(db, key: bookID) {
                print( "Found book with ID \(book.id ?? fallbackValue): \(book.title)")
                book.title = ""
                try book.update(db)
                print("New name is \(book.title)")
            } else {
                print("No borrower with id \(bookID)")
            }
        }
    } catch {
        print("error")
    }
}

func addBorrower(borrowerName: String, borrowerEmail: String, borrowerPhone: String, dbQueue: DatabaseQueue)
{
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
                    print("id: \(borrower.id ?? fallbackValue), name: \(borrower.name), email: \(borrower.email), phone: \(borrower.phone)")
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


@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/bookDatabase.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connection succesful")
            //availableBooks(dbQueue: dbQueue)
            //unavailableBooks(dbQueue: dbQueue)
            //loanBook(bookID: 5, borrowerID: 0, dbQueue: dbQueue)
            //returnBook(loanID: 4, dbQueue: dbQueue)
            //searchBook(bookID: 1, dbQueue: dbQueue)
            //searchBook(bookSearch: "The Alchemist", dbQueue: dbQueue)
            //addBook( bookTitle: "The Picture of Dorian Gray", bookAuthor: "Oscar Wilde",bookYearPublished: 1890, dbQueue: dbQueue)
            //addBorrower(borrowerName: "Archie Domaneschi", borrowerEmail: "ArchieDomaneschi@student.onslow.school.nz", borrowerPhone: "0210220230", dbQueue: dbQueue)
            searchBorrower(borrowerSearch: "s", dbQueue: dbQueue)

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

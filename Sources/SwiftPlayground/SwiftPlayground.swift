// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

// Fallback value for missing IDs.
let fallbackValue: Int = -1

// Creates variable that is the current year.
let year = Calendar.current.component(.year, from: Date())

// Max phone number length
let maxPhoneNumber = 12

// Max email length
let maxEmail = 100

// Table formatting.
let idWidth = 6
let titleCutOff = 23
let titleWidth = 25
let authorCutOff = 18
let authorWidth = 20
let yearWidth = 6
let availabilityWidth = 20
let nameCutOff = 18
let nameWidth = 20
let emailWidth = 35
let phoneCutOff = 12
let phoneWidth = 14
let bookIDWidth = 8
let dateBorrowedCutOff = 10
let dateBorrowedWidth = 12

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

/// Displays the column names for the book heading.
func bookHeading() {
    print("------------------------------------------------------------------------------")
    print("ID    TITLE                    AUTHOR              YEAR  AVAILABILITY")
    print("------------------------------------------------------------------------------")

}

/// Prints a row of book information on a table.
///
/// Checks whether a book is currently on loan.
/// It then assigns a status: Available or On Loan.
/// The books details are then formatted into columns to ensure the output is aligned for the table format.
/// 
/// - Parameters:
///     - book: the book records to be displayed.
///     - db: the database connection.
func bookTable(book: Books, db: Database) {
    do {

        // Checks if the book is currently being loaned.
        let onLoan =
            try Loans
            .filter(
                Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil
            )
            .fetchOne(db)
        var status: String

        // Displays books as available if not on loan.
        if onLoan == nil {
            status = "Available"
            // Displays books as unavailable if on loan.
        } else {
            status = "On Loan"
        }

        // Formats values neatly for terminal output.
        let id = formatID(id: book.id).padding(toLength: idWidth, withPad: " ", startingAt: 0)
        let title = book.title.prefix(titleCutOff).padding(toLength: titleWidth, withPad: " ", startingAt: 0)
        let author = book.author.prefix(authorCutOff).padding(toLength: authorWidth, withPad: " ", startingAt: 0)
        let year = String(book.yearPublished).padding(
            toLength: yearWidth, withPad: " ", startingAt: 0)
        let availability = status.padding(toLength: availabilityWidth, withPad: " ", startingAt: 0)

        // Prints a signal formatted row in the book table.
        print("\(id)\(title)\(author)\(year)\(availability)")
    } catch {
        print("error")
    }
}

/// Displays the column names for the borrower heading.
func borrowerHeading() {
    print("------------------------------------------------------------------------------")
    print("ID    NAME                PHONE         EMAIL")
    print("------------------------------------------------------------------------------")

}

/// Prints a row of borrower information on a table.
///
/// The borrower details are formatted into columns to ensure the output is aligned for the table format.
/// 
/// - Parameters:
///     - borrower: the borrower records to be displayed.
///     - db: the database connection.
func borrowerTable(borrower: Borrowers, db: Database) {

    // Formats values neatly for terminal output.
    let id = formatID(id: borrower.id).padding(toLength: idWidth, withPad: " ", startingAt: 0)
    let name = borrower.name.prefix(nameCutOff).padding(toLength: nameWidth, withPad: " ", startingAt: 0)
    let email = borrower.email
    let phone = borrower.phone.prefix(phoneCutOff).padding(toLength: phoneWidth, withPad: " ", startingAt: 0)

    // Prints a signal formatted row in the borrower table.
    print("\(id)\(name)\(phone)\(email)")

}

/// Displays the column names for the loan heading.
func loanHeading() {
    print("------------------------------------------------------------------------------")
    print("ID    BOOKID  BOOK                     BORROWER            DATE BORROWED")
    print("------------------------------------------------------------------------------")

}

/// Prints a row of loan information on a table.
///
/// The loan details are formatted into columns to ensure the output is aligned for the table format.
/// 
/// - Parameters:
///     - loan: the loan records to be displayed.
///     - book: the book records to be displayed.
///     - borrower: the borrower records to be displayed.
///     - db: the database connection.
func loanTable(loan: Loans, borrower: Borrowers, book: Books, db: Database) {

    // Formats values neatly for terminal output.
    let id = formatID(id: loan.id).padding(toLength: idWidth, withPad: " ", startingAt: 0)
    let bookID = String(loan.bookID).padding(
        toLength: bookIDWidth, withPad: " ", startingAt: 0)
    let bookTitle = book.title.prefix(titleCutOff).padding(toLength: titleWidth, withPad: " ", startingAt: 0)
    let borrower = borrower.name.prefix(nameCutOff).padding(toLength: nameWidth, withPad: " ", startingAt: 0)
    let dateBorrowed = loan.dateBorrowed.prefix(dateBorrowedCutOff).padding(
        toLength: dateBorrowedWidth, withPad: " ", startingAt: 0)

    // Prints a signal formatted row in the borrower table.
    print("\(id)\(bookID)\(bookTitle)\(borrower)\(dateBorrowed)")
}

/// Displays the menu options.
///
/// This function prints all options the user can choice to do.
func showMenu() {
    print(
        """
        -----------------------------
        LIBRARY BOOK BORROWING SYSTEM
        -----------------------------
        Choose an option:
        1  - Search Book (includes view all books)
        2  - Loan Book
        3  - Return Book
        4  - Add new Book
        5  - Delete Book
        6  - Edit Book Records
        7  - Search Borrower (includes view all borrowers)
        8  - Register new Borrower
        9  - Delete Borrower
        10 - Edit Borrower Records
        11 - Search Active Loans (includes view all loans)
        0  - Exit
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

    // Ask for book ID.
    print("enter book ID: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue

    // Ask for borrower ID.
    print("enter borrower ID: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in
            print("")
            // Fetches borrower using inputed borrower ID, and prints out a summary of borrower information if it finds it, and if not prints that it can't be found.
            if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                print("Found borrower: \(borrower.summary())")
            } else {
                print("No borrower found")
                return
            }
            // Fetches book using inputed book, and prints out a summary of book information if it finds it, and if not prints that it can't be found.
            if let book = try Books.fetchOne(db, key: bookID) {
                print("Found book: \(book.summary()) ")
            } else {
                print("No book found)")
                return
            }

            // Checking if book has an active loan by searching with a loan with the same id and where the date returned is still  nil.
            let alreadyLoaned =
                try Loans
                .filter(Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil)
                .fetchOne(db)

            // If active loan exists, let the user know and stop function.
            if alreadyLoaned != nil {
                print("book already loaned")
                return
            }

            // Creates a new loan using entered borrower and book ID and current date.
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

    // Ask user for book id to return.
    print("enter book id to return: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Checking if book has an active loan by searching with a loan with the same id and where the date returned is still  nil.
            if var loan =
                try Loans
                .filter(
                    Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil
                )
                .fetchOne(db)
            {

                // Fetches borrower connected to loan.
                let borrower = try Borrowers.fetchOne(db, key: loan.borrowerID)

                // Fetches book connected to loan.
                let book = try Books.fetchOne(db, key: loan.bookID)

                // Displays information about loan.
                print(
                    "Found loan: ID: \(formatID(id: loan.id)) | Book ID: \(formatID(id: book?.id)) | Book Title: \(book?.title ?? "N/A") | Borrower ID: \(formatID(id: borrower?.id)) | Borrower Name: \(borrower?.name ?? "N/A") | Date Borrowed: \(loan.dateBorrowed) | Date Returned: \(currentDate())"
                )

                // Checks if book has already been loaned.
                if loan.dateReturned != nil {
                    print("book already returned")
                    return
                }

                // Updates loan date returned with current date.
                loan.dateReturned = currentDate()
                try loan.update(db)

                print("book returned")

            } else {

                // Displays error message if there is no active loan with entered book ID.
                print("No current loan found")
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

    // Ask for user input for book or author name, and if the user enters nothing, it prints all books.
    print("enter book or author name ")
    print("or enter nothing and view all books:  ")
    let bookSearch = readLine() ?? ""
    do {
        try dbQueue.read { db in

            // Fetches all books from database.
            let books = try Books.fetchAll(db)

            // Tracks if any matching books were found.
            var bookFound = false

            // Heading for book table
            bookHeading()

            // Loops through each book in database.
            for book in books {

                // If user enters nothing prints all books with their information.
                if bookSearch == "" {
                    bookTable(book: book, db: db)
                    bookFound = true
                }

                // Check if their is a book that matches the input by user.
                if book.title.lowercased().contains(bookSearch.lowercased())
                    || book.author.lowercased().contains(bookSearch.lowercased())
                {

                    // Checking if book has an active loan by searching with a loan with the same id and where the date returned is still  nil.
                    let onLoan =
                        try Loans
                        .filter(
                            Loans.Columns.bookID == book.id && Loans.Columns.dateReturned == nil
                        )
                        .fetchOne(db)

                    // Displays books as available if not on loan.
                    if onLoan == nil {
                        bookTable(book: book, db: db)

                        // Displays books as unavailable if on loan.
                    } else {
                        bookTable(book: book, db: db)
                    }

                    // Matching book found.
                    bookFound = true
                }

                // Displays message if no book is found.
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

    // Asks user for book title.
    print("enter book title: ")
    let bookTitle = readLine() ?? ""

    // Asks for book author.
    print("enter author name: ")
    let bookAuthor = readLine() ?? ""

    // Asks for book year published.
    print("enter year published: ")
    let bookYearPublished = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Creates new book using entered information.
            let newBook = Books(
                id: nil, title: bookTitle, author: bookAuthor, yearPublished: bookYearPublished)

            // Checks that the title is not empty.
            if newBook.title == "" {
                print("please enter a book title")
                return
            }

            // Checks that the author is not empty.
            if newBook.author == "" {
                print("please enter a book author")
                return
            }

            // Checks that the year published is valid.
            if newBook.yearPublished < 0 || newBook.yearPublished > year {
                print("please enter a valid year published")
                return
            }

            // Inserts new book into database and tells user.
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

    // Asks user for book ID.
    print("enter book id: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Attempts to fetch book with inputed book ID.
            if let book = try Books.fetchOne(db, key: bookID) {

                // Prints summary of the book found.
                print("Found book with \(book.summary())")

                // Searches if there is an active loan associated with this book.
                let activeLoan =
                    try Loans
                    .filter(
                        Loans.Columns.bookID == bookID && Loans.Columns.dateReturned == nil
                    )
                    .fetchOne(db)

                // Doesn't delete book if it on loan.
                if activeLoan != nil {
                    print("can't delete book as book is currently on loan")
                    return
                }

                // Deletes book if there is no current loan associated and tells user.
                try book.delete(db)
                print("book succesfuly deleted")
            } else {

                // Tells user if there is no matching book found to entered book ID.
                print("No book found")
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

    // Asks user for book ID.
    print("enter book id: ")
    let bookID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Attempts to fetch book with inputed book ID.
            if var book = try Books.fetchOne(db, key: bookID) {

                // Variable indicating if any changes were made to a book.
                var changesMade = false

                // Prints summary of book found.
                print("Found book with \(book.summary())")

                // Asks user for new book title, and if user presses nothing it changes nothing from the records.
                print("enter new book title or press enter to keep \(book.title): ")
                if let newTitle = readLine(), newTitle != "" {
                    book.title = newTitle
                    changesMade = true
                }

                // Asks user for new author name, and if user presses nothing it changes nothing from the records.
                print("enter new book author or press enter to keep \(book.author): ")
                if let newAuthor = readLine(), newAuthor != "" {
                    book.author = newAuthor
                    changesMade = true
                }

                // Asks user for new year published that is valid, and if user presses nothing it changes nothing from the records.
                print(
                    "enter new book year published or press enter to keep \(book.yearPublished): ")
                if let newYearPublished = readLine(), newYearPublished != "" {

                    // Input = new year published if new year published is same as or over 0 and same as or under current year
                    if let newYearPublished = Int(newYearPublished),
                        newYearPublished >= 0,
                        newYearPublished <= year
                    {

                        book.yearPublished = newYearPublished
                        changesMade = true
                    } else {
                        print("invalid year entered")
                    }
                }

                // If changes were made it prints out changes.
                if changesMade {

                    // Updating records with new information.
                    try book.update(db)

                    // Telling user it's been updated and showing new information.
                    print("book succesfully updated")
                    print(book.summary())
                } else {

                    // If no changes were made it tells the user.
                    print("no changes made")
                }

            } else {

                // Tells user if there is no matching book found to entered book ID.
                print("No book found")
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

    // Asks user for borrower name.
    print("enter borrower name: ")
    let borrowerName = readLine() ?? ""

    // Asks user for borrower email.
    print("enter borrower email: ")
    let borrowerEmail = readLine() ?? ""

    // Makes sure email length is 100 characters or less.
    if borrowerEmail.count > 100 {
        print("Email length too long, must be \(maxEmail) characters or less")
        return
    }

    // makes sure email is valid because it has @ sign.
    if !borrowerEmail.contains("@") {
        print("invalid email, no '@' sign")
        return
    }

    // Asks user for borrower email.
    print("enter borrower phone: ")
    let borrowerPhone = readLine() ?? ""

    // Makes sure phone number is 12 characters or less.
    if borrowerPhone.count > maxPhoneNumber {
        print("Phone number too long, must be \(maxPhoneNumber) characters or less")
        return
    }
    do {
        try dbQueue.write { db in

            // Creates new borrower using entered information.
            let newBorrower = Borrowers(
                id: nil, name: borrowerName, email: borrowerEmail, phone: borrowerPhone)

            // Checks that the name is not empty.
            if newBorrower.name == "" {
                print("please enter a borrower name")
                return
            }

            // Checks that the email is not empty.
            if newBorrower.email == "" {
                print("please enter a borrower email")
                return
            }

            // Checks that the phone is not empty.
            if newBorrower.phone == "" {
                print("please enter a borrower phone")
                return
            }

            // Inserts new borrower into database and tells user.
            try newBorrower.insert(db)
            print("borrower succesfully added")
        }
    } catch {
        print("error")
    }
}

/// Searches for borrower by name.
///
/// Prompts for a search.
/// Matches borrower by name.
/// If no input given, displays all borrowers in library.
/// Shows borrower information.
///
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
func searchBorrower(dbQueue: DatabaseQueue) {

    // Ask for user input for borrower name.
    print("enter borrower name:")
    print("or enter nothing and view all borrowers:  ")
    let borrowerSearch = readLine() ?? ""
    do {
        try dbQueue.read { db in

            // Fetches all borrowers from database.
            let borrowers = try Borrowers.fetchAll(db)

            // Tracks if any matching borrowers were found.
            var borrowerFound = false

            // Heading for borrower table
            borrowerHeading()

            // Loops through each borrower in database.
            for borrower in borrowers {

                // If user enters nothing all borrowers are printed
                if borrowerSearch == "" {
                    borrowerTable(borrower: borrower, db: db)
                    borrowerFound = true
                }

                // Check if their is a book that matches the input by user.
                if borrower.name.lowercased().contains(borrowerSearch.lowercased()) {

                    // Prints information about borrower(s) found.
                    borrowerTable(borrower: borrower, db: db)

                    // Matching borrower found.
                    borrowerFound = true

                }
            }
            // Displays message if no borrower is found.
            if borrowerFound == false {
                print("no borrower found")
            }
        }
    } catch {
        print("error")
    }
}

/// Searches for loan by book title or borrwer name.
///
/// Prompts for a search.
/// Matches loan by title or name.
/// If no input given, displays all loans.
/// Shows book information.
///
/// - Parameter: dbQueue: The GRDB database queue used for access to database.
func searchLoan(dbQueue: DatabaseQueue) {

    // Ask for user input for borrower name or book title.
    print("enter book title or borrower name:")
    print("or enter nothing and view all loans:  ")
    let loanSearch = readLine() ?? ""
    do {
        try dbQueue.read { db in

            // Fetches all loans from database that are active.
            let loans =
                try Loans
                .filter(Loans.Columns.dateReturned == nil)
                .fetchAll(db)

            // Tracks if any matching loans were found.
            var loanFound = false

            // Heading for loans table.
            loanHeading()

            // Loops through each borrower in database.
            for loan in loans {

                // Fetches the related book and borrower for each loan.
                if let book = try Books.fetchOne(db, key: loan.bookID),
                    let borrower = try Borrowers.fetchOne(db, key: loan.borrowerID)
                {

                    // If no search is entered prints out all active loans.
                    if loanSearch == "" {
                        loanTable(loan: loan, borrower: borrower, book: book, db: db)
                        loanFound = true
                    }

                    // Check if their is a loan that matches the input by user.
                    if book.title.lowercased().contains(loanSearch.lowercased())
                        || borrower.name.lowercased().contains(loanSearch.lowercased())
                    {
                        // Displays matching loans in table.
                        loanTable(loan: loan, borrower: borrower, book: book, db: db)
                        loanFound = true
                    }
                }
            }
            // Displays message if no borrower is found.
            if loanFound == false {
                print("no borrower or book found")
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

    // Asks user for borrower ID.
    print("enter borrower id: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Attempts to fetch borrower with inputed borrower ID.
            if var borrower = try Borrowers.fetchOne(db, key: borrowerID) {

                // Variable indicating if any changes were made to a borrower.
                var changesMade = false

                // Prints summary of borrower found.
                print("Found borrower with \(borrower.summary())")

                // Asks user for new borrower name, and if user presses nothing it changes nothing from the records.
                print("enter new borrower name or press enter to keep \(borrower.name): ")
                if let newName = readLine(), newName != "" {
                    borrower.name = newName
                    changesMade = true
                }

                // Asks user for new borrower email, and if user presses nothing it changes nothing from the records.
                print("enter new borrower email or press enter to keep \(borrower.email): ")
                if let newEmail = readLine(), newEmail != "" {
                    borrower.email = newEmail
                    changesMade = true
                }

                // Asks user for new borrower phone, and if user presses nothing it changes nothing from the records.
                print("enter new borrower phone number or press enter to keep \(borrower.phone): ")
                if let newPhone = readLine(), newPhone != "" {
                    borrower.phone = newPhone
                    changesMade = true
                }

                // If changes were made it prints out changes.
                if changesMade {

                    // Updating records with new information.
                    try borrower.update(db)

                    // Telling user it's been updated and showing new information.
                    print("borrower succesfully updated")
                    print(borrower.summary())
                } else {

                    // If no changes made tell user.
                    print("no changes made")
                }

            } else {

                // Tells user if there is no matching book found to entered book ID.
                print("No borrower found")
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

    // Asks user for borrower ID.
    print("enter borrower id: ")
    let borrowerID = Int(readLine() ?? "") ?? fallbackValue
    do {
        try dbQueue.write { db in

            // Attempts to fetch borrower with inputed borrower ID.
            if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {

                // Prints summary of the borrower found.
                print("Found borrower with \(borrower.summary())")

                // Searches if there is an active loan associated with this borrower.
                let activeLoan =
                    try Loans
                    .filter(
                        Loans.Columns.borrowerID == borrowerID && Loans.Columns.dateReturned == nil
                    )
                    .fetchOne(db)

                // Doesn't delete borrower if it on loan.
                if activeLoan != nil {
                    print("can't delete borrower as borrower has books loaned")
                    return
                }

                // Deletes borrower if there is no current loan associated and tells user.
                try borrower.delete(db)
                print("borrower succesfuly deleted")
            } else {

                // Tells user if there is no matching borrower found to entered borrower ID.
                print("No borrower found")
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

            // Created database queue for access to database.
            let dbQueue = try DatabaseQueue(path: dbpath)

            // Confirms that database connection is succeful to user.
            print("database connection succesful")

            // Controls wether the program runs.
            var running = true

            // So program loops.
            while running {

                // Displays menu options to user.
                showMenu()

                // Reads user choice.
                let option = readLine()

                // Runs selected function.
                switch option?.uppercased() {
                case "1":

                    // Searches for books.
                    searchBook(dbQueue: dbQueue)
                case "2":

                    // Loans books to borrower.
                    loanBook(dbQueue: dbQueue)
                case "3":

                    // Returns a borrowed book.
                    returnBook(dbQueue: dbQueue)
                case "4":

                    // Adds a new book.
                    addBook(dbQueue: dbQueue)
                case "5":

                    // Deletes a book.
                    deleteBook(dbQueue: dbQueue)
                case "6":

                    // Edits book information.
                    editBook(dbQueue: dbQueue)
                case "7":

                    // Searches for borrowers.
                    searchBorrower(dbQueue: dbQueue)
                case "8":

                    // Adds a borrower.
                    addBorrower(dbQueue: dbQueue)
                case "9":

                    // Delete a borrower.
                    deleteBorrower(dbQueue: dbQueue)
                case "10":

                    // Edits borrower information.
                    editBorrower(dbQueue: dbQueue)

                case "11":

                    // Searches for Loans.
                    searchLoan(dbQueue: dbQueue)
                case "0":

                    // Ends program.
                    running = false
                    print("goodbye")

                // Handles invalid menu input.
                default:
                    print("please enter a valid input")
                }

                // Pauses program until user enters to continue.
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

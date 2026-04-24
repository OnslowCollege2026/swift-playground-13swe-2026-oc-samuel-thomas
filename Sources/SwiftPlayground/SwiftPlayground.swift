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
            let borrowerID = 0

            try dbQueue.read { db in
                if let borrower = try Borrowers.fetchOne(db, key: borrowerID) {
                    print("Found borrower with ID \(borrower.id): \(borrower.name)")
                } else {
                    print("No borrower with id \(borrowerID)")
                }
            }
            
        } catch {
            print(error)
        }
    }
}

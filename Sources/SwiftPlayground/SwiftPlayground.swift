// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

struct borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
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
        case name = "name"
        case email = "email"
        case phone = "phone"
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
                if let borrowerID = try borrower.fetchOne(db, key: borrowerID) {
                    print("Found borrower with ID \(borrower.id): \(borrower.name)")
                } else {
                    print("No purchaser with id \(borrowerID)")
                }
            }
            
        } catch {
            print(error)
        }
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB


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
                if let borrowerID = try Purchaser.fetchOne(db, key: purchaserID) {
                    print("Found purchaser with ID \(purchaser.id): \(purchaser.name)")
                } else {
                    print("No purchaser with id \(purchaserID)")
                }
                if let someOtherPerson = try Purchaser.fetchOne(db, key: 2) {
                    print("Found purchaser with ID \(someOtherPerson.id): \(someOtherPerson.name)")
                } else {
                    print("No purchaser with id 2")
                }
                if let item = try Item.fetchOne(db, key: 1) {
                    print("Found item with ID \(item.id): \(item.name)")
                } else {
                    print("No item with id 1")
                }

            }
            
        } catch {
            print(error)
        }
    }
}

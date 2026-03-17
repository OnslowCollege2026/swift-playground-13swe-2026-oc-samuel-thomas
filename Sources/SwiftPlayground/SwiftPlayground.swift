// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

/// A reservation at the cafe, made by a purchaser
struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// the Purchaser ID
    let id: Int
    /// The name of the purchaser
    var name: String
    /// the number of people in the purchaser's party (default 1)
    var count: Int
    /// The table reserved by the purchaser
    var reservedTable: Int

    enum CodingKeys: String, CodingKey {
        case id = "Purchaser ID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "Reserved Table"
    }
}

struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// the Order ID
    let id: Int
    /// the Purchaser ID of the purchaser who made the order
    var purchaserID: Int
    /// the name of the item ordered
    var amount: Int
    /// the price of the item ordered

    enum CodingKeys: String, CodingKey {
        case id = "Order ID"
        case purchaserID = "Purchaser ID"
        case amount = "Amount"
    }
}

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// the Item ID
    let id: Int
    /// the name of the item
    var name: String
    /// the price of the item
    var price: Double

    enum CodingKeys: String, CodingKey {
        case id = "Item ID"
        case name = "Name"
        case price = "Price"
    }
}

struct OrderLine: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// the Order ID of the order that the order line belongs to
    var id: Int
    /// the Item ID of the item ordered in the order line
    var itemID: Int
    /// the quantity of the item ordered in the order line
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case id = "Order ID"
        case itemID = "Item ID"
        case quantity = "Quantity"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connection succesful")

            try dbQueue.read { database in
                try database.dumpSchema()
            }
            let purchaserID = 1

            try dbQueue.read { db in
                let purchaser = try Purchaser.fetchOne(db, key: purchaserID)
                if let purchaser {
                    print("Found purchaser with ID \(purchaser.id): \(purchaser.name)")
                } else {
                    print("No purchaser with id \(purchaserID)")
                }
            }
            
        } catch {
            print(error)
        }
    }
}

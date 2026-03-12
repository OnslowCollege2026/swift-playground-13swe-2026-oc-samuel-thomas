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


@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("database connectoin succesful")

            try dbQueue.read { database in
            try database.dumpSchema()}
        } catch {
            print(error)
        }
    }
}

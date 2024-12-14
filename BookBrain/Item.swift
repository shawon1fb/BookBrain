//
//  Item.swift
//  BookBrain
//
//  Created by Shahanul Haque on 12/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

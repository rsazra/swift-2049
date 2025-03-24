//
//  Item.swift
//  swift-2049
//
//  Created by Rajbir Singh Azra on 2025-03-23.
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

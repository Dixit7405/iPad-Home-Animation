//
//  Item.swift
//  Ipad Demo
//
//  Created by Dixit Rathod on 23/07/24.
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

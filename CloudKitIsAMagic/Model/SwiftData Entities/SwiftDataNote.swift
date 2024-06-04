//
//  SwiftDataNote.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 05.06.2024.
//

import Foundation
import SwiftData

@Model
class SwiftDataNote: Identifiable {
    var id: UUID = UUID.init()
    var title: String = ""
    var colorIndex: Int = 0

    init(title: String, colorIndex: Int) {
        self.title = title
        self.colorIndex = colorIndex
    }
}

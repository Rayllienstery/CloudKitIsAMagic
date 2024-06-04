//
//  NoteColor.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 05.06.2024.
//

import Foundation
import UIKit

protocol ColorRepserentable: Identifiable {
    var colorRepresentation: UIColor { get }
}

enum NoteColor: Int, CaseIterable, ColorRepserentable {
    var id: Self { self }
    
    case red, blue, green, purple, orangle

    var colorRepresentation: UIColor {
        switch self {
        case .red: .red
        case .blue: .blue
        case .green: .green
        case .purple: .purple
        case .orangle: .orange
        }
    }
}

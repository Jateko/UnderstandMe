//
//  Color+Extensions.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI

public extension Color {
  static func fromRGB(red: Double, green: Double, blue: Double, opacity: Double = 255) -> Color {
    Color(red: red/255, green: green/255, blue: blue/255, opacity: opacity/255)
  }
  
  static var trBlack: Color {
    fromRGB(red: 47, green: 47, blue: 47)
  }
  
  static var trPink: Color {
    fromRGB(red: 193, green: 117, blue: 255)
  }
}

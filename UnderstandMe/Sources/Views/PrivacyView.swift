//
//  PrivacyView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI

struct PrivacyView: View {
  private let title: String
  private let description: String
  
  init(title: String, description: String) {
    self.title = title
    self.description = description
  }
  
  var body: some View {
    VStack {
      Text(title)
        .font(.largeTitle)
        .padding()
      
      Text(description)
        .padding()
      
      Spacer()
    }
  }
}


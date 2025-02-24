//
//  TextAreaView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI

struct TextAreaView: View {
  @Binding var text: String
  private var placeholder: String
  private var languageTitle: String
  
  init(text: Binding<String>,
       placeholder: String,
       languageTitle: String) {
    self._text = text
    self.placeholder = placeholder
    self.languageTitle = languageTitle
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(languageTitle)
        .font(.headline)
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
      
      Text(text.isEmpty ? placeholder : text)
        .foregroundColor(.white.opacity(0.6))
        .font(.body)
        .padding([.horizontal, .bottom], 16)
      
      Spacer()
      
      Button(action: {
        
      }) {
        Image("copy")
      }
      .frame(width: 24, height: 24)
      .padding()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.trBlack)
    .cornerRadius(16)  // Rounded corners
  }
}


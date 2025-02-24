//
//  LanguageListView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI


struct LanguageListView: View {
  @Environment(\.dismiss) private var dismiss
  // List of language codes.
  let languages = ["en", "es", "fr", "de", "it", "ru"]
  @Binding var selectedLanguage: String
  
  var body: some View {
    List(languages, id: \.self) { code in
      HStack {
        Text(code.uppercased())
          .font(.body)
          .foregroundColor(.white)
        
        Spacer()
        
        if selectedLanguage == code {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
      // Set a custom background color for each row.
      .listRowBackground(Color.trBlack)
      // Hide the row separator (iOS 15+)
      .listRowSeparator(.hidden)
      .contentShape(Rectangle())
      .onTapGesture {
        selectedLanguage = code
        dismiss()
      }
    }
    .listStyle(PlainListStyle())
    .background(Color.trBlack)
  }
}


//
//  SettingsView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
  @ObservedObject
  var viewModel: SettingsViewModel
  
  
  init(viewModel: SettingsViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(spacing: 12) {
        ForEach(viewModel.menuItems) { item in
          HStack {
            Image(systemName: item.icon)
              .foregroundColor(.blue)
              .font(.title2)
            
            Text(item.title)
              .font(.headline)
              .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
              .foregroundColor(.gray)
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(12)
          .onTapGesture {
            viewModel.handleSettingsButtonTap(item: item)
          }
        }
      }
      .padding()
      .navigationTitle("Settings")
      .sheet(isPresented: $viewModel.showPrivacy) {
        PrivacyView(title: "Privacy Policy", description: TranslatorViewModel.privacy)
      }
      .sheet(isPresented: $viewModel.showTerms) {
        PrivacyView(title: "Terms & Conditions", description: TranslatorViewModel.privacy)
      }
    }
  }
}

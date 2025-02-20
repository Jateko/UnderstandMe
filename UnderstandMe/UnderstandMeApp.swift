//
//  UnderstandMeApp.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 19.02.25.
//

import SwiftUI

@main
struct UnderstandMeApp: App {
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor.white,
      .font: UIFont.preferredFont(forTextStyle: .title2)
    ]
  
    // Assign appearance to both scrollEdge and standard appearances
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    // For compact nav bars
    UINavigationBar.appearance().compactAppearance = appearance
  }
  
  var body: some Scene {
    WindowGroup {
      let translatorService = TranslatorService()
      let spechRecognizer = SpeechRecognizer(translator: translatorService)
      let vm = TranslatorViewModel(speechRecognizer: spechRecognizer)
      TranslatorView(viewModel: vm)
        .background(Color.black)
    }
  }
}

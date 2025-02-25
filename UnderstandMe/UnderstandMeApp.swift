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
    
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        let translator = TranslatorService()
        let spechRecognizer = SpeechRecognizer()
        let vm = TranslatorViewModel(speechRecognizer: spechRecognizer,
                                     translator: translator)
//        TranslatorView(viewModel: vm)
        ContentView()
//          .background(Color.black)
//          .transition(.opacity)
      }
    }
  }
}

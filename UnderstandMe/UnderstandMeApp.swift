//
//  UnderstandMeApp.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 19.02.25.
//

import SwiftUI

@main
struct UnderstandMeApp: App {
  @State private var showSplash = true
  
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
        //        if showSplash {
        //          SplashView()
        //            .transition(.opacity)
        //        } else {
        let translator = TranslatorService()
        let spechRecognizer = SpeechRecognizer()
        let vm = TranslatorViewModel(speechRecognizer: spechRecognizer,
                                     translator: translator)
        TranslatorView(viewModel: vm)
          .background(Color.black)
          .transition(.opacity)
        //
//      }
      }
      
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            showSplash = false
          }
        }
      }
    }
  }
}

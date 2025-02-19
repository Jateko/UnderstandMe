//
//  ContentView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 19.02.25.
//

import SwiftUI
import MLKitTranslate

struct ContentView: View {
  private var translator: MLKitTranslateWrapper!
  
  init(translator: MLKitTranslateWrapper!) {
    self.translator = translator
  }
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
      //        .foregroundStyle(.tint)
      Text("Hello, world!")
      Button(action: {
        self.translator.translate()
      }) {
        Text("Click Me")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()
    }
    .padding()
  }
}

class MLKitTranslateWrapper {
  func translate() {
    print("start translating...")
    Task {
      do {
        let op = TranslatorOptions(sourceLanguage: .english, targetLanguage: .russian)
        let tr = Translator.translator(options: op)
        let conditions = ModelDownloadConditions(
          allowsCellularAccess: false,
          allowsBackgroundDownloading: true
        )
        try await tr.downloadModelIfNeeded(with: conditions)
        
        let translatedText = try await tr.translate("Hello")
        print("translated text: \(translatedText)")
      } catch {
        print("error during translation: \(error.localizedDescription)")
      }
    }
  }
}

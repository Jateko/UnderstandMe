//
//  TranslatorViewModel.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 20.02.25.
//

import Foundation

final class TranslatorViewModel: ObservableObject {
  private var speechRecognizer: SpeechRecognizer
  
  init(speechRecognizer: SpeechRecognizer) {
    self.speechRecognizer = speechRecognizer
  }
  
  func start() {
    Task {
      do {
        try await self.speechRecognizer.start()
      } catch {
        print(error)
      }
    }
  }
  
  func stop() async {
    await self.speechRecognizer.stop()
  }
}

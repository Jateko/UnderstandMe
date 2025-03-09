//
//  TranslatorViewModel.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 20.02.25.
//

import Foundation
import UIKit

@MainActor
final class TranslatorViewModel: ObservableObject {
  private let speechRecognizer: SpeechRecognizer
  private let translator: TranslatorService
  
  @Published var recognizedText: String = ""
  @Published var translatedText: String = ""
  @Published var sourceLanguage: String = "en" {
    didSet {
      Task {
        await restartSpeechRecognizer()
      }
    }
  }
  @Published var targetLanguage: String = "ru" {
    didSet {
      
    }
  }
  
  @Published var showTargetLanguages: Bool = false
  @Published var showSourceLanguages: Bool = false
  @Published var isRecording: Bool = false
  
  private var lastTapTime: Date? = nil
  private let throttleInterval: TimeInterval = 1.0
  
  init(speechRecognizer: SpeechRecognizer,
       translator: TranslatorService) {
    self.speechRecognizer = speechRecognizer
    self.translator = translator
  }
  
  private func start() async {
    do {
      try await self.speechRecognizer.start(for: sourceLanguage)
      isRecording = true
      await self.speechRecognizer.setUpdateRecognizedText { [weak self] text in
        Task { [weak self] in
          guard let self else { return }
          await self.handleSpeechUpdates(text: text)
        }
      }
    } catch {
      print(error)
    }
  }
  
  private func stop() async {
    await self.speechRecognizer.stop()
    isRecording = false
  }
  
  private func handleSpeechUpdates(text: String) async {
    recognizedText = text
    translatedText = await translator.translate(text, targetLanguage: targetLanguage, sourceLanguage: sourceLanguage)
  }
  
  private func restartSpeechRecognizer() async {
    if await speechRecognizer.isRunning {
      await stop()
    }
    await start()
  }
  
  func handleSpeechButton() {
    Task { [weak self] in
      guard let self else { return }
      
      let now = Date()
      
      if let lastTap = lastTapTime, now.timeIntervalSince(lastTap) < throttleInterval {
        print("Tap throttled!")
        return  // Ignore the tap if within the throttle interval
      }
      
      lastTapTime = now
      
      await speechRecognizer.isRunning ? await stop() : await start()
    }
  }
  
  func copyTextToClipboard(_ text: String) {
    UIPasteboard.general.string = text
  }
}

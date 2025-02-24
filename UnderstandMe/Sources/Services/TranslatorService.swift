//
//  TranslatorService.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 20.02.25.
//

import Foundation
import MLKitTranslate

actor TranslatorService {
  
  private var skipUntilModelDownload = false
  
  func translate(_ message: String, targetLanguage: String, sourceLanguage: String) async -> String {
    guard !skipUntilModelDownload else { return "SKIPPPPPPPPPPP" }
    let source = TranslateLanguage(rawValue: sourceLanguage)
    let target = TranslateLanguage(rawValue: targetLanguage)
    let options = TranslatorOptions(sourceLanguage: source, targetLanguage: target)
    let englishGermanTranslator = Translator.translator(options: options)
    
    let conditions = ModelDownloadConditions(
      allowsCellularAccess: false,
      allowsBackgroundDownloading: true
    )
    do {
      skipUntilModelDownload = true
      try await englishGermanTranslator.downloadModelIfNeeded(with: conditions)
      let translatedText = try await englishGermanTranslator.translate(message)
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
      //      print("\(formatter.string(from: date)) --> translatedText \(translatedText)")
      skipUntilModelDownload = false
      return translatedText
    } catch {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
      print("\(formatter.string(from: date)) --> error = \(error)")
    }
    return "NO TRANSLATION"
  }
}

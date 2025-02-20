//
//  SpeechRecognizer.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 20.02.25.
//

import Foundation
import Speech

enum RecognizerError: Error {
  case nilRecognizer
  case notAuthorizedToRecognize
  case notPermittedToRecord
  case recognizerIsUnavailable
  case generalError
  
  var message: String {
    switch self {
    case .nilRecognizer: return "Can't initialize speech recognizer"
    case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
    case .notPermittedToRecord: return "Not permitted to record audio"
    case .recognizerIsUnavailable: return "Recognizer is unavailable"
    case .generalError: return "something happend"
    }
  }
}

actor SpeechRecognizer: NSObject {
  
  private var audioEngine: AVAudioEngine?
  private var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private var recognizer: SFSpeechRecognizer?
  
  private let translator: TranslatorService
  
  init(translator: TranslatorService) {
    self.translator = translator
  }
  
  func start() async throws {
    do {
      guard try await checkPermissions() else { return }
      recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru"))
      try prepareEngine()
      guard let audioEngine, let request else { return }
      task = recognizer?.recognitionTask(with: request, delegate: self)
      
//      task = recognizer?.recognitionTask(with: request, resultHandler: { [weak self] result, error in
//        Task { [weak self] in
//          await self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
//        }
//      })
    }
  }
  
  func stop() async {
    
  }
  
  private func configureSpeechRecognizer() {
    print("configureSpeechRecognizer")
    request = SFSpeechAudioBufferRecognitionRequest()
    request?.shouldReportPartialResults = true
    if recognizer?.supportsOnDeviceRecognition == true {
      request?.requiresOnDeviceRecognition = true
    }
    request?.taskHint = .dictation
    
    if #available(iOS 16, *) {
      request?.addsPunctuation = true
    }
  }
  
  private func prepareEngine() throws {
    configureSpeechRecognizer()
    configureEngine()
    
    guard let audioEngine, let request else { throw RecognizerError.generalError }
    
    let inputNode = audioEngine.inputNode
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      guard let self else { return }
      Task { [weak self] in
        await self?.handleIncomingAudiobuffer(buffer)
      }
    }
    
    audioEngine.prepare()
    try audioEngine.start()
  }
  
  private func configureEngine() {
    do {
      audioEngine = AVAudioEngine()
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Error configuring audioEngine: \(error)")
    }
    print("engine prepared")
  }
  
  private func handleIncomingAudiobuffer(_ audiobuffer: AVAudioPCMBuffer) async {
    request?.append(audiobuffer)
  }
  
  private func checkPermissions() async throws -> Bool {
    guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
      throw RecognizerError.notAuthorizedToRecognize
    }
    guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
      throw RecognizerError.notPermittedToRecord
    }
    return true
  }
}

extension SpeechRecognizer: SFSpeechRecognitionTaskDelegate {
  // Called when the task first detects speech in the source audio
  nonisolated func speechRecognitionDidDetectSpeech(_ task: SFSpeechRecognitionTask) {
    print("zazaza speechRecognitionDidDetectSpeech, task state = \(task.state) isFinishing = \(task.isFinishing)")
  }
  
  // Called for all recognitions, including non-final hypothesis
  nonisolated func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
    print("zazaza didHypothesizeTranscription \(transcription.formattedString)")
    //    print("zazaza ---- \(transcription.segments.compactMap { $0})")
//    Task {
//      let res = await self.translate(transcription.formattedString)
//      await self.updateText?(transcription.formattedString)
//      await self.updateTranslatedText?(res)
//    }
  }
  
  // Called only for final recognitions of utterances. No more about the utterance will be reported
  nonisolated func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
    print("zazaza didFinishRecognition task state = \(task.state) isFinishing = \(task.isFinishing) recognitionResult = \(recognitionResult.bestTranscription.formattedString)")
//    Task {
//      let res = await self.translate(recognitionResult.bestTranscription.formattedString)
//      await self.updateText?(recognitionResult.bestTranscription.formattedString)
//      await self.updateTranslatedText?(res)
//    }
  }
  
  // Called when the task is no longer accepting new audio but may be finishing final processing
  nonisolated func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
    print("zazaza speechRecognitionTaskFinishedReadingAudio")
  }
  
  // Called when the task has been cancelled, either by client app, the user, or the system
  nonisolated func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
    print("zazaza speechRecognitionTaskWasCancelled")
  }
  
  // Called when recognition of all requested utterances is finished.
  // If successfully is false, the error property of the task will contain error information
  nonisolated func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
    print("zazaza didFinishSuccessfully \(successfully)")
  }
}

extension SFSpeechRecognizer {
  static func hasAuthorizationToRecognize() async -> Bool {
    await withCheckedContinuation { continuation in
      requestAuthorization { status in
        continuation.resume(returning: status == .authorized)
      }
    }
  }
}

extension AVAudioSession {
  func hasPermissionToRecord() async -> Bool {
    await withCheckedContinuation { continuation in
      requestRecordPermission { authorized in
        continuation.resume(returning: authorized)
      }
    }
  }
}

import MLKitTranslate

actor TranslatorService {
  
  private var skipUntilModelDownload = false
  
  func translate(_ message: String) async -> String {
    guard !skipUntilModelDownload else { return "SKIPPPPPPPPPPP" }
    let options = TranslatorOptions(sourceLanguage: .russian, targetLanguage: .english)
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

//
//  TranslatorView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 19.02.25.
//

import Foundation
import SwiftUI

struct TranslatorView: View {
  @ObservedObject var viewModel: TranslatorViewModel
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.black
          .ignoresSafeArea(.all, edges: .bottom)
        
        VStack {
          HStack {
            configureButton {
              viewModel.showSourceLanguages = true
            }
            
            Spacer()
            
            Button(action: {
              
            }) {
              Image("icon_change_lang")
            }.disabled(true)
            
            Spacer()
            
            configureButton {
              viewModel.showTargetLanguages = true
            }
          }
          .padding(.vertical, 20)
          
          TextAreaView(text: $viewModel.recognizedText,
                       placeholder: "Your speech...",
                       languageTitle: viewModel.sourceLanguage)
          .padding(.bottom, 16)
          TextAreaView(text: $viewModel.translatedText,
                       placeholder: "Translated text...",
                       languageTitle: viewModel.targetLanguage)
          
          Spacer()
          
          Button(action: {
            print("speech")
            viewModel.handleSpeechButton()
          }) {
            Image("microphone")
          }
          .frame(width: 56, height: 56)
          .background(viewModel.isRecording ? Color.gray : Color.trPink)
          .cornerRadius(28)
          
          Spacer(minLength: 16)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Comprehand Me", displayMode: .inline)
        .navigationTitle("Home")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: SettingsView(viewModel: SettingsViewModel())) {
              Image(systemName: "info.circle")
            }
          }
        }
        .sheet(isPresented: $viewModel.showSourceLanguages) {
          LanguageListView(selectedLanguage: $viewModel.sourceLanguage)
        }
        .sheet(isPresented: $viewModel.showTargetLanguages) {
          LanguageListView(selectedLanguage: $viewModel.targetLanguage)
        }
        // Show alert
        .alert("Siri and Dictation are disabled", isPresented: $viewModel.showErrorAlert) {
          Button("Cancel", role: .cancel) {
            viewModel.openSettings()
            Task {
              await self.viewModel.stop()
            }
          }
        } message: {
          Text("Siri and Dictation are currently disabled. To enable Dictation, please go to Settings > General > Keyboard and turn on 'Enable Dictation'.")
        }
      }
    }
  }
  
  @ViewBuilder
  private func configureButton(action: @escaping () -> Void) -> some View {
    Button(action: {
       print("action 1")
      action()
    }) {
      Text("Configure")
        .foregroundColor(.white)
    }
    .frame(width: 148.0, height: 48.0)
    .background(Color.trBlack)
    .cornerRadius(24.0)
  }
  
  
}

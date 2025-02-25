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
          .background(Color.trPink)
          .cornerRadius(28)
          
          Spacer(minLength: 16)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Understand Me", displayMode: .inline)
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

import SwiftUI

struct ContentView: View {
    // A long multi-paragraph text for simulation
    let fullText = """
    Once upon a time in a land far, far away, there was a small village that thrived on the kindness of its inhabitants. The people of the village were known for their generosity and the beautiful songs they sang every morning. The gentle breeze carried these melodies through the winding streets, reaching even the distant hills and forests.

    Among these villagers was a young dreamer who believed that words had the power to change the world. With each stroke of the pen, they documented stories of hope, adventure, and the endless possibilities that life had to offer. The dreamer wrote of brave knights, wise elders, and the magic of nature that wove its way into every corner of their existence.

    As the seasons changed, the dreamer’s writings inspired not only their village but also travelers from distant lands. The words danced on the pages like flames in the night, lighting up hearts and kindling the desire to create a better tomorrow. It was said that reading these stories was like embarking on a journey to a realm where dreams and reality intertwined.

    And so, with every tap of the keyboard, the simulation of this grand tale unfolded, one word at a time, reminding us that every great story begins with a single word.
    """
    
    @State private var displayText: String = ""
    @State private var words: [String] = []
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Text(displayText)
                    .padding()
                    .id("TextView")
            }.frame(width: .infinity, height: 50)
            .onAppear {
                // Split the full text into individual words
                words = fullText.split(separator: " ").map { String($0) }
                
                // Timer to append one word at a time
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    if currentIndex < words.count {
                        // Append the next word, adding a space if needed
                        displayText += (displayText.isEmpty ? "" : " ") + words[currentIndex]
                        currentIndex += 1
                        
                        // Auto-scroll to the bottom of the text view
                        withAnimation {
                            proxy.scrollTo("TextView", anchor: .bottom)
                        }
                    } else {
                        timer.invalidate() // Stop the timer when finished
                    }
                }
            }
        }
    }
}

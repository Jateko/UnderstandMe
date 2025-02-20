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
//  @StateObject private var keyboardObserver = KeyboardObserver()
  @FocusState private var isFocused: Bool
  @State private var showPicker: Bool = false
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.black
          .ignoresSafeArea(.all, edges: .bottom)
        
        VStack {
          HStack {
            configureButton {
              showPicker = true
            }.sheet(isPresented: $showPicker) {
              Color.red.ignoresSafeArea()
            }
            
            Spacer()
            
            Button(action: {
              print("change language")
            }) {
              Image("icon_change_lang")
            }
            
            Spacer()
            
            configureButton {
              print("fskl;;klsdfkl;sfds;flk")
            }
          }
          .background(Color.red)
          .padding(.vertical, 20)
          
          TextView(isFocused: $isFocused).padding(.bottom, 16)
          TextView(isFocused: $isFocused)
//            .frame(minHeight: 180, maxHeight: 200)
          
          Spacer()
          
          Button(action: {
            print("speech")
              viewModel.start()
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
        .navigationBarTitle("My Nav Bar Title", displayMode: .inline)
        .onTapGesture {
          isFocused = false
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
  
  func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil, from: nil, for: nil)
  }

}

struct TextView: View {
//  @State private var text: String = "Enter text here..."
//  
  var isFocused: FocusState<Bool>.Binding
//  
//  var body: some View {
//    VStack {
////      HStack {
//        Text("English")
//          .fontWeight(.light)
//          .foregroundStyle(.white).opacity(0.64)
//        
////      }
//    .padding([.top, .leading], 20)
////      Spacer()
////      TextEditor(text: $text)
////        .padding([.leading, .trailing, .bottom], 20)
////        .padding(.top, 16)
////        .frame(minHeight: 180, maxHeight: 200)
////        .focused(isFocused)
//      
//      Text("fdsl;fkjsdlfj")
//        .padding(20)
//        .background(Color.trPink.opacity(0.12))
//    }
////    .frame(minHeight: 180, maxHeight: 200)
//    .background(Color.trBlack)
//    .cornerRadius(8)
//  }
  var body: some View {
    // Outer container, aligning text at the top-left
    VStack(alignment: .leading) {
      // Language label
      Text("Russian")
        .font(.headline)
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.red)
      
      Text("Enter text to translate…")
        .foregroundColor(.white.opacity(0.6))
        .font(.body)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(.red)
      
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.trBlack)
    .cornerRadius(16)  // Rounded corners
  }
}

public extension Color {
  static func fromRGB(red: Double, green: Double, blue: Double, opacity: Double = 255) -> Color {
    Color(red: red/255, green: green/255, blue: blue/255, opacity: opacity/255)
  }
  
  static var trBlack: Color {
    fromRGB(red: 47, green: 47, blue: 47)
  }
  
  static var trPink: Color {
    fromRGB(red: 193, green: 117, blue: 255)
  }
}


//import Combine
//
//class KeyboardObserver: ObservableObject {
//    @Published var keyboardHeight: CGFloat = 0
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillShowNotification)
//            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification))
//            .sink { notification in
//                self.keyboardHeight = Self.extractKeyboardHeight(from: notification)
//            }
//            .store(in: &cancellables)
//        
//        NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillHideNotification)
//            .sink { _ in
//                self.keyboardHeight = 0
//            }
//            .store(in: &cancellables)
//    }
//    
//    private static func extractKeyboardHeight(from notification: Notification) -> CGFloat {
//        guard
//            let userInfo = notification.userInfo,
//            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//        else {
//            return 0
//        }
//        return rect.height
//    }
//}

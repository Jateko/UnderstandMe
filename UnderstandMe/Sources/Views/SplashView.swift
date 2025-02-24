//
//  SplashView.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import SwiftUI

struct SplashView: View {
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      VStack {
        Image("icon_splash")
          .resizable()
          .scaledToFit()
          .frame(width: 150, height: 150)
          .foregroundColor(.white)
        
        Text("UnderstandMe")
          .font(.largeTitle)
          .foregroundColor(.white)
          .bold()
      }
    }
  }
}

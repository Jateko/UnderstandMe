//
//  UnderstandMeApp.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 19.02.25.
//

import SwiftUI

@main
struct UnderstandMeApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(translator: MLKitTranslateWrapper())
        }
    }
}

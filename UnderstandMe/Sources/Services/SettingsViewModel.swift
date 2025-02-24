//
//  SettingsViewModel.swift
//  UnderstandMe
//
//  Created by Pavel Afonin on 24.02.25.
//

import Foundation
import UIKit

enum SettingmenuItem: CaseIterable, Identifiable {
    case terms
    case privacy
    case support

    var id: Self { self }  // Unique ID for SwiftUI

    var title: String {
        switch self {
        case .terms: return "Terms"
        case .privacy: return "Privacy"
        case .support: return "Support"
        }
    }

    var icon: String {
        switch self {
        case .terms: return "doc.text"
        case .privacy: return "lock"
        case .support: return "headphones"
        }
    }
}

final class SettingsViewModel: ObservableObject {
  @Published
  var menuItems: [SettingmenuItem] = [.terms, .privacy, .support]
  
  @Published var showTerms: Bool = false
  @Published var showPrivacy: Bool = false
  
  func handleSettingsButtonTap(item: SettingmenuItem) {
    switch item {
    case .terms:
      showTerms.toggle()
    case .privacy:
      showPrivacy.toggle()
    case .support:
      openSupportEmail()
    }
  }
  
  private func openSupportEmail() {
    let supportEmail = "support@example.com"
    let subject = "Support Request"
    let body = "Hello, I need help with..."
    
    let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    let mailtoURL = "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)"
    
    if let url = URL(string: mailtoURL), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    } else {
      print("Cannot open email app")
    }
  }
}

extension TranslatorViewModel {
  static let privacy = """
  Privacy Notice for UnderstandMe
  Last updated: February 24, 2025

  This Privacy Notice for UnderstandMe ("we," "us," or "our") describes how and why we might access, collect, store, use, and/or share ("process") your personal information when you use our services ("Services"), including when you:

  - Download and use our mobile application (UnderstandMe) or any other application of ours that links to this Privacy Notice.
  - Engage with us in other related ways, including any sales, marketing, or events.

  Questions or Concerns?
  Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at support@understandme.com.

  Summary of Key Points
  This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below.

  What personal information do we process?
  When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use.

  Do we process any sensitive personal information?
  We do not process sensitive personal information.

  Do we collect any information from third parties?
  We do not collect any information from third parties.

  How do we process your information?
  We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with legal requirements.

  When and with whom do we share personal information?
  We may share information in specific situations and with third parties.

  What are your rights?
  Depending on where you are located, privacy laws may provide certain rights regarding your personal information.

  How do you exercise your rights?
  The easiest way to exercise your rights is by submitting a data subject access request or by contacting us at support@understandme.com.

  Want to learn more?
  Review the full Privacy Notice below.
  """
}

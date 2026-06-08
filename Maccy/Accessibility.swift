import AppKit

struct Accessibility {
  private static var allowed: Bool { AXIsProcessTrustedWithOptions(nil) }

  static func check() {
    guard !allowed else {
      return
    }

    AXIsProcessTrustedWithOptions([
      kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true
    ] as CFDictionary)
  }
}

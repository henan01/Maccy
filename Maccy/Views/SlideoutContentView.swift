import SwiftUI

struct SlideoutContentView: View {
  @Environment(AppState.self) var appState
  @State private var previewItem: HistoryItemDecorator?

  var body: some View {
    VStack {
      ToolbarView()

      if let item = previewItem {
        PreviewItemView(item: item)
      } else if let pasteStack = appState.history.pasteStack,
        appState.navigator.pasteStackSelected {
        PasteStackPreviewView(pasteStack: pasteStack)
      } else {
        EmptyView()
      }
    }
    .padding(.horizontal)
    .padding(.bottom)
    .padding(.top, Popup.verticalPadding)
    .task(id: appState.navigator.leadHistoryItem?.id) {
      let item = appState.navigator.leadHistoryItem

      guard let item else {
        previewItem = nil
        return
      }

      try? await Task.sleep(for: .milliseconds(150))
      guard !Task.isCancelled else { return }

      previewItem = item
    }
  }

}

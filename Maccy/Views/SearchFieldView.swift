import SwiftUI

struct SearchFieldView: View {
  var placeholder: LocalizedStringKey
  @Binding var query: String
  @State private var localQuery: String
  @State private var searchTask: Task<Void, Never>?

  @Environment(AppState.self) private var appState

  init(placeholder: LocalizedStringKey, query: Binding<String>) {
    self.placeholder = placeholder
    self._query = query
    self._localQuery = State(initialValue: query.wrappedValue)
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: Popup.cornerRadius, style: .continuous)
        .fill(Color.secondary)
        .opacity(0.1)
        .frame(height: 23)

      HStack {
        Image(systemName: "magnifyingglass")
          .frame(width: 11, height: 11)
          .padding(.leading, 5)
          .opacity(0.8)

        TextField(placeholder, text: $localQuery)
          .disableAutocorrection(true)
          .lineLimit(1)
          .textFieldStyle(.plain)
          .onSubmit {
            searchTask?.cancel()
            query = localQuery
            appState.select()
          }

        if !localQuery.isEmpty {
          Button {
            searchTask?.cancel()
            localQuery = ""
            query = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .frame(width: 11, height: 11)
              .padding(.trailing, 5)
          }
          .buttonStyle(.plain)
          .opacity(0.9)
        }
      }
    }
    .onChange(of: localQuery) {
      searchTask?.cancel()
      let nextQuery = localQuery
      searchTask = Task { @MainActor in
        try? await Task.sleep(for: .milliseconds(600))
        guard !Task.isCancelled else { return }
        query = nextQuery
      }
    }
    .onChange(of: query) {
      if localQuery != query {
        localQuery = query
      }
    }
    .onDisappear {
      searchTask?.cancel()
    }
  }
}

#Preview {
  return List {
    SearchFieldView(placeholder: "search_placeholder", query: .constant(""))
    SearchFieldView(placeholder: "search_placeholder", query: .constant("search"))
  }
  .frame(width: 300)
  .environment(\.locale, .init(identifier: "en"))
}

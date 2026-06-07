import SwiftUI

struct VisualEffectView: NSViewRepresentable {
  let visualEffectView = NSVisualEffectView()

  var material: NSVisualEffectView.Material = .popover
  var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

  func makeNSView(context: Context) -> NSVisualEffectView {
    return visualEffectView
  }

  func updateNSView(_ view: NSVisualEffectView, context: Context) {
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
  }
}

#if !MACCY_DISABLE_GLASS_EFFECT
  @available(macOS 26.0, *)
  struct GlassEffectView: NSViewRepresentable {
    let glassEffectView = NSGlassEffectView()

    var style: NSGlassEffectView.Style = .regular

    func makeNSView(context: Context) -> NSGlassEffectView {
      return glassEffectView
    }

    func updateNSView(_ view: NSGlassEffectView, context: Context) {
      glassEffectView.style = style
    }
  }
#else
  struct GlassEffectView: View {
    var body: some View {
      VisualEffectView()
    }
  }
#endif

#Preview {
  VisualEffectView(
    material: .popover,
    blendingMode: .behindWindow
  )
}

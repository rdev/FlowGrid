//
//  View+readSize.swift
//
//  Created by Max Rovensky on 20/02/2021.
//  Inspired and totally not ripped off from https://fivestars.blog/swiftui/flexible-swiftui.html
//

import SwiftUI

// Size reader modifier for views
extension View {
  // This needs to be aware of the scale factor, since this will be called AFTER the scale modification has been applied,
  // and it will loop into itself and give us a wrong measurement. Once we know the scale factor, it needs to be accounted for, so
  // that the `.frame()` modifier used for scaling up the rows actually has effect
  func readSize(_ scaleFactor: CGFloat = 1, onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: CGSize(width: geometryProxy.size.width / scaleFactor, height: geometryProxy.size.height / scaleFactor))
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

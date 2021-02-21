//
//  FlowGrid.swift
//
//  Created by Max Rovensky on 20/02/2021.
//  Inspired and totally not ripped off from https://fivestars.blog/swiftui/flexible-swiftui.html
//

import SwiftUI

@available(iOS 14, OSX 11.0, tvOS 14, watchOS 7, *)
public struct FlowGrid<Data: Collection, Content: View>: View where Data.Element: Hashable {
  private let items: Data
  private let rowHeight: CGFloat
  private let spacing: CGFloat
  private let disableFill: Bool
  private let content: (Data.Element) -> Content

  @State private var viewportWidth: CGFloat = 0

  public init(items: Data, rowHeight: CGFloat, spacing: CGFloat, content: @escaping (Data.Element) -> Content) {
    self.items = items
    self.rowHeight = rowHeight
    self.spacing = spacing
    self.content = content
    self.disableFill = false
  }

  public init(items: Data, rowHeight: CGFloat, spacing: CGFloat, disableFill: Bool, content: @escaping (Data.Element) -> Content) {
    self.items = items
    self.rowHeight = rowHeight
    self.spacing = spacing
    self.content = content
    self.disableFill = disableFill
  }

  // Default spacing to 0 cause it's clearly better looking
  public init(items: Data, rowHeight: CGFloat, content: @escaping (Data.Element) -> Content) {
    self.items = items
    self.rowHeight = rowHeight
    self.content = content
    self.spacing = 0
    self.disableFill = false
  }

  public var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
      // Read and store the viewport width before we get started
      Color.clear
        .frame(height: 1)
        .readSize { size in
          viewportWidth = size.width
        }

      // Pass viewport width, layout parameters and data to the main grid view
      FlowGridView(
        viewportWidth: viewportWidth,
        items: items,
        rowHeight: rowHeight,
        spacing: spacing,
        disableFill: disableFill,
        content: content
      )
    }
  }
}

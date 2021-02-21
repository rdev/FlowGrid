//
//  FlowGridView.swift
//
//  Created by Max Rovensky on 20/02/2021.
//  Inspired and totally not ripped off from https://fivestars.blog/swiftui/flexible-swiftui.html
//

import SwiftUI

// Grid row needs two things - elements inside it and the scale factor
// Since we don'tknow the scale factor befure the row is built, it defaults to `1`
private struct FlowRow<T>: Hashable where T: Hashable {
  var items: [T]
  var scaleFactor: CGFloat = 1
}

// Main grid view
struct FlowGridView<Data: Collection, Content: View>: View where Data.Element: Hashable {
  let viewportWidth: CGFloat
  let items: Data
  let rowHeight: CGFloat
  let spacing: CGFloat
  let disableFill: Bool
  let content: (Data.Element) -> Content

  @State var itemSizes: [Data.Element: CGSize] = [:]

  var body : some View {
    let rows = calculateRows()

    // Sorry, <11.0 users, scroll performance is really shit otherwise :/
    LazyVStack(alignment: .leading, spacing: spacing) {
      ForEach(rows, id: \.self) { row in
        HStack(spacing: spacing) {
          ForEach(row.items, id: \.self) { element in
            content(element)
              .frame(height: disableFill ? rowHeight : rowHeight * row.scaleFactor)
              .fixedSize()
              .readSize(row.scaleFactor) { size in // Size reader needs to be aware of the scale factor
                itemSizes[element] = size
              }
          }
        }
      }
    }
  }

  fileprivate func calculateRows() -> [FlowRow<Data.Element>] {
    var rows: [FlowRow<Data.Element>] = [.init(items: [])]
    var currentRow = 0
    var remainingWidth = viewportWidth

    for item in items {
      // Get the element size we measured in the parent component
      let elementSize = itemSizes[item, default: CGSize(width: viewportWidth, height: 1)]

      // If we have space in the row to fit the width of the item, dew it
      if remainingWidth - elementSize.width >= 0 {
        rows[currentRow].items.append(item)
      } else {
        // Otherwise, we're done with the row, so let's do some math
        // First, let's calculate the total width of all items in the row so far
        let totalWidth = rows[currentRow].items.reduce(0) {
          $0 + itemSizes[$1, default: CGSize(width: viewportWidth, height: 1)].width
        }
        // Now calculate the vertical scale factor, that will ensure that leftover horizontal space is filled completely
        // and write it to the row
        rows[currentRow].scaleFactor = viewportWidth / totalWidth

        // Move on to the next row
        currentRow = currentRow + 1
        rows.append(.init(items: [item], scaleFactor: 1))
        remainingWidth = viewportWidth
      }

      // Update remaining width
      remainingWidth = remainingWidth - elementSize.width
    }

    return rows
  }
}

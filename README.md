# FlowGrid

Flow layout type grid for SwiftUI that can fill available space.


## Usage

### Install

Install using Swift Package Manager:

```swift
dependencies: [
  .package(url: "https://github.com/rdev/FlowGrid.git")
]
```

### Import and use

```swift
import SwiftUI
import FlowGrid

struct PhotoGrid: View {
  var images: [Identifiable]

  var body: some View {
    VStack {
       // It's a good idea to use GeometryReader on a parent VStack to get relative row height. We'll just use 200
      FlowGrid(items: images, rowHeight: 200) { image in
        Image(image.name)
          .resizable()
          .scaledToFil()
      }
    }
  }
}

```

### Initializer Options

```swift
init(
  items: Data, // A Collection of Identifiable items to use as data
  rowHeight: CGFloat, // Baseline row height. Rows WILL end up slightly higher than this when scaled up if fill is enabled
  spacing: CGFloat, // Spacing between collection items. Defaults to zero cause it's obviously better looking that way
  disableFill: Bool, // Disables row scaling. Good for cases when you don't need to fill the view, i.e. a "tag cloud"
  content: @escaping (Data.Element) -> Content // Render you stuff here
) {}
```
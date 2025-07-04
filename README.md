# SelectableRowsViewKit

A flexible and customizable SwiftUI component for creating selectable row lists with various selection indicator styles.

## Features

- ✅ **Single and Multiple Selection**: Support for both single and multiple selection modes
- 🎨 **Customizable Selection Indicators**: Choose from checkmark, checkbox, or toggle styles
- 🌈 **Custom Colors**: Per-item color customization for selection indicators
- 🔧 **Flexible Content**: Use default content or provide custom row layouts
- 📱 **iOS Native**: Built with SwiftUI best practices and native iOS design patterns
- ♿️ **Accessibility**: Full accessibility support with proper semantic markup

## Requirements

- iOS 16.0+
- macOS 13.0+
- watchOS 9.0+
- tvOS 16.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gsanta75/SelectableRowsViewKit.git", from: "1.0.0")
]
```

Or add it through Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use

## Quick Start

### Basic Usage

```swift
import SwiftUI
import SelectableRowsViewKit

struct ContentView: View {
    @StateObject private var viewModel = SelectionViewModel<String>()
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        List {
            SelectionRowsView(viewModel: viewModel, elements: $items)
        }
    }
}
```

### Single Selection Mode

```swift
@StateObject private var viewModel = SelectionViewModel<String>(mode: .single)
```

###

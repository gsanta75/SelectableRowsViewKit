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

## Demo App

This repository includes a comprehensive demo app that showcases all the features of SelectableRowsViewKit. The demo app is located in the `DemoApp/` directory and demonstrates:

- **Multiple selection with default styling** - Person list with green checkmarks
- **Single selection with custom row content** - Happiness levels with emoji indicators
- **Checkbox style selection** - Fruits list with yellow checkbox indicators
- **Toggle style with custom colors** - Numbers list with conditional coloring (even/odd)
- **Selection summary** - Real-time count of selected items
- **Clear all functionality** - Reset all selections at once

### Running the Demo App

1. Clone this repository
2. Open `SelectableRowsViewKit.xcworkspace` or the Package.swift file in Xcode
3. Select the `DemoApp` scheme
4. Build and run on your preferred simulator or device

The demo app provides an excellent starting point for understanding how to integrate and customize SelectableRowsViewKit in your own projects.

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

### Selection Styles

#### Checkmark Style (Default)
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectorColor(.green)
```

#### Checkbox Style
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectorStyle(.checkbox)
    .selectorColor(.blue)
```

#### Toggle Style
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectorStyle(.toggle)
    .selectorColor(.red)
```

### Custom Row Content

```swift
SelectionRowsView(viewModel: viewModel, elements: $items) { item, isSelected in
    HStack {
        Image(systemName: "star.fill")
        Text(item)
            .font(.headline)
        Spacer()
        if isSelected {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
    .padding(.vertical, 4)
}
```

### Per-Item Color Customization

```swift
SelectionRowsView(viewModel: viewModel, elements: $numbers)
    .selectorStyle(.toggle)
    .colorItemSelectionProvider { number in
        number % 2 == 0 ? .blue : .red
    }
```

## Advanced Usage

### Working with Custom Data Types

```swift
struct Person: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
}

extension Person: CustomStringConvertible {
    var description: String { "\(name), \(age)" }
}

@StateObject private var viewModel = SelectionViewModel<Person>()
@State private var people = [
    Person(name: "Alice", age: 25),
    Person(name: "Bob", age: 30)
]

SelectionRowsView(viewModel: viewModel, elements: $people) { person, isSelected in
    VStack(alignment: .leading) {
        Text(person.name)
            .font(.headline)
        Text("Age: \(person.age)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .foregroundColor(isSelected ? .blue : .primary)
}
```

### Selection Management

```swift
// Check selection count
let count = viewModel.selectionCount

// Check if any items are selected
let hasSelection = viewModel.hasSelection

// Check if specific item is selected
let isSelected = viewModel.isSelected(someItem)

// Programmatically select items
viewModel.selectAll(items)

// Clear all selections
viewModel.deselectAll()

// Toggle specific item
viewModel.updateSelection(specificItem)
```

## View Modifiers

### `.selectorStyle(_:)`
Sets the visual style for selection indicators:
- `.checkmark` - Shows/hides checkmark icon
- `.checkbox` - Shows filled/empty checkbox
- `.toggle` - Shows toggle switch
- `nil` - Uses tap gesture only (default)

### `.selectorColor(_:)`
Sets a uniform color for all selection indicators.

### `.colorItemSelectionProvider(_:)`
Provides per-item color customization with a closure that receives each item and returns an optional Color.

## Data Requirements

Your data types need to conform to `Hashable` to work with SelectableRowsViewKit. For custom string representation in default row content, implement `CustomStringConvertible`.

## List Integration

SelectableRowsView works seamlessly with SwiftUI's `List` and supports:
- ✅ Delete functionality (swipe to delete)
- ✅ Move functionality (drag to reorder)
- ✅ Edit mode
- ✅ Sections and headers/footers

```swift
List {
    Section("My Items") {
        SelectionRowsView(viewModel: viewModel, elements: $items)
    }
}
.toolbar {
    EditButton()
}
```

## Architecture

### SelectionViewModel
The core view model that manages selection state:
- Supports both single and multiple selection modes
- Thread-safe with `@MainActor`
- Observable with `@Published` properties
- Type-safe with generic constraints

### SelectionRowsView
The main view component:
- Generic over any `Hashable` type
- Customizable row content via ViewBuilder
- Environment-based styling system
- Automatic list integration

### SelectorToggleStyle
Custom toggle style implementation:
- Three visual styles (checkmark, checkbox, toggle)
- Color customization support
- Consistent behavior across styles

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Author

Giuseppe Santaniello - [@gsanta75](https://github.com/gsanta75)

## Changelog

### 1.0.0
- Initial release
- Basic selection functionality
- Multiple selection styles
- Custom row content support
- Per-item color customization
- Comprehensive demo app
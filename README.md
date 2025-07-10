# SelectableRowsViewKit

A flexible and customizable SwiftUI component for creating selectable row lists with various selection indicator styles.

## Features

- ✅ **Single and Multiple Selection**: Support for both single and multiple selection modes
- 🔒 **Required Selection**: Option to require at least one element to be selected in single mode
- 🎨 **Customizable Selection Indicators**: Choose from checkmark, checkbox, toggle, or tap styles
- 📍 **Flexible Alignment**: Position selection indicators on leading or trailing side
- 🌈 **Custom Colors**: Per-item color customization for selection indicators
- 🔧 **Flexible Content**: Use default content or provide custom row layouts
- 📱 **iOS Native**: Built with SwiftUI best practices and native iOS design patterns
- ♿️ **Accessibility**: Full accessibility support with proper semantic markup
- 🎯 **Tap Areas**: Choose between element-only or full-row tap areas

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
    .package(url: "https://github.com/gsanta75/SelectableRowsViewKit.git", from: "1.3.1")
]
```

Or add it through Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use

## Demo App

This repository includes a comprehensive demo app that showcases all the features of SelectableRowsViewKit. The demo app is located in the `DemoApp/` directory and demonstrates:

- **Multiple selection with default styling** - Person list with tap-on-row selection
- **Single selection with custom row content** - Happiness levels with emoji indicators
- **Checkbox style selection** - Fruits list with yellow checkbox indicators on leading side
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

### Required Selection

For single selection mode, you can require that at least one element is always selected:

```swift
@StateObject private var viewModel = SelectionViewModel<String>(
    mode: .single, 
    requireSelection: true
)

var body: some View {
    List {
        SelectionRowsView(viewModel: viewModel, elements: $items)
    }
    .onAppear {
        // Ensure initial selection when required
        if viewModel.requiresSelection && !viewModel.hasSelection && !items.isEmpty {
            viewModel.updateSelection(items[0])
        }
    }
}
```

## Selection Styles

### Tap on Element (Default)
Default behavior with tap gesture on element content only:
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectorColor(.green)
```

### Tap on Row
Tap gesture covers the entire row area:
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.tapOnRow)
    .selectorColor(.green)
```

### Checkmark Style
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.checkmark)
    .selectorColor(.blue)
```

### Checkbox Style
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.checkbox)
    .selectorColor(.yellow)
```

### Toggle Style
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.toggle)
    .selectorColor(.red)
```

## Selection Indicator Alignment

All visual selection indicators (checkmark, checkbox, toggle) support alignment positioning:

### Leading Alignment
Position indicators on the left side of the row:
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.checkbox(alignment: .leading))
    .selectorColor(.yellow)
```

### Trailing Alignment (Default)
Position indicators on the right side of the row:
```swift
SelectionRowsView(viewModel: viewModel, elements: $items)
    .selectionWith(.toggle(alignment: .trailing))
    .selectorColor(.red)
```

### Mixed Alignment Example
```swift
VStack {
    // Leading checkboxes
    SelectionRowsView(viewModel: viewModel1, elements: $items1)
        .selectionWith(.checkbox(alignment: .leading))
    
    // Trailing toggles
    SelectionRowsView(viewModel: viewModel2, elements: $items2)
        .selectionWith(.toggle(alignment: .trailing))
}
```

## Custom Row Content

Use the `selectionRowContent` parameter to provide custom layouts:

```swift
SelectionRowsView(
    viewModel: viewModel, 
    elements: $items,
    selectionRowContent: { item, isSelected in
        HStack {
            Image(systemName: "star.fill")
            Text(item)
                .font(.headline)
                .foregroundColor(isSelected ? .blue : .primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
)
```

## Per-Item Color Customization

```swift
SelectionRowsView(viewModel: viewModel, elements: $numbers)
    .selectionWith(.toggle)
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

SelectionRowsView(
    viewModel: viewModel, 
    elements: $people,
    selectionRowContent: { person, isSelected in
        VStack(alignment: .leading) {
            Text(person.name)
                .font(.headline)
            Text("Age: \(person.age)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .foregroundColor(isSelected ? .blue : .primary)
    }
)
```

### Selection Management

```swift
// Check selection count
let count = viewModel.selectionCount

// Check if any items are selected
let hasSelection = viewModel.hasSelection

// Check if selection is required
let isRequired = viewModel.requiresSelection

// Check if specific item is selected
let isSelected = viewModel.isSelected(someItem)

// Programmatically select items
viewModel.selectAll(items)

// Clear all selections (respects requireSelection)
viewModel.deselectAll()

// Toggle specific item
viewModel.updateSelection(specificItem)
```

## View Modifiers

### `.selectionWith(_:)`
Sets the visual style for selection indicators:
- `.checkmark` - Shows/hides checkmark icon (supports alignment)
- `.checkbox` - Shows filled/empty checkbox (supports alignment)
- `.toggle` - Shows toggle switch (supports alignment)
- `.tapOnElement` - Tap gesture on element content only (default)
- `.tapOnRow` - Tap gesture on entire row area

#### Alignment Support
Visual indicators support alignment positioning:
- `.checkmark(alignment: .leading)` - Checkmark on left side
- `.checkbox(alignment: .trailing)` - Checkbox on right side (default)
- `.toggle(alignment: .leading)` - Toggle on left side

### `.selectorColor(_:)`
Sets a uniform color for all selection indicators.

### `.colorItemSelectionProvider(_:)`
Provides per-item color customization with a closure that receives each item and returns an optional Color.

## Selection Modes

### Multiple Selection (Default)
```swift
@StateObject private var viewModel = SelectionViewModel<String>()
// or explicitly:
@StateObject private var viewModel = SelectionViewModel<String>(mode: .multiple)
```

### Single Selection
```swift
@StateObject private var viewModel = SelectionViewModel<String>(mode: .single)
```

### Single Selection with Required Selection
```swift
@StateObject private var viewModel = SelectionViewModel<String>(
    mode: .single, 
    requireSelection: true
)
```

When using `requireSelection: true`:
- Users cannot deselect the currently selected item
- `deselectAll()` will have no effect
- You should ensure an initial selection is made

## Data Requirements

Your data types need to conform to `Hashable` to work with SelectableRowsViewKit. For custom string representation in default row content, implement `CustomStringConvertible`.

## List Integration

SelectionRowsView works seamlessly with SwiftUI's `List` and supports:
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
- Optional required selection for single mode
- Thread-safe with `@MainActor`
- Observable with `@Published` properties
- Type-safe with generic constraints

### SelectionRowsView
The main view component:
- Generic over any `Hashable` type
- Customizable row content via ViewBuilder
- Environment-based styling system
- Automatic list integration

### Selection Style ViewModifiers
Modular ViewModifier architecture:
- `CheckboxSelection` - Checkbox indicator with tap gesture
- `CheckmarkSelection` - Checkmark icon with button interaction
- `ToggleSelection` - Standard iOS toggle switch
- `TapElementSelection` - Tap gesture on element content
- `TapRowSelection` - Tap gesture on entire row
- Easy to extend with custom selection styles

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Author

Giuseppe Santaniello - [@gsanta75](https://github.com/gsanta75)

## Changelog

### 1.3.1
- **INTERNAL**: Cleaned up public API exposure
- **INTERNAL**: Made ViewModifiers internal implementation details
- **INTERNAL**: Improved code maintainability and documentation
- **INTERNAL**: Unified selection logic with single entry point

### 1.3.0
- **NEW**: Added alignment support for selection indicators
- **NEW**: Support for `.leading` and `.trailing` alignment on checkmark, checkbox, and toggle indicators
- **NEW**: Convenience static properties for cleaner API (`.checkbox` instead of `.checkbox()`)
- **IMPROVED**: Enhanced toggle rendering with proper positioning and sizing
- **IMPROVED**: Better layout handling for left-aligned indicators
- Enhanced documentation with alignment examples

### 1.2.0
- **BREAKING CHANGE**: Replaced `SelectorToggleStyle` with ViewModifier architecture
- Added `.tapOnRow` selection style for full-row tap areas
- Renamed `.tap` to `.tapOnElement` for clarity
- Renamed `rowContent` parameter to `selectionRowContent` for API clarity
- Updated API from `.selectorStyle()` to `.selectionWith()`
- Improved code modularity and scalability
- Enhanced documentation and examples

### 1.1.0
- Added `requireSelection` parameter for single selection mode
- Improved API design with cleaner enum structure
- Enhanced documentation with required selection examples

### 1.0.0
- Initial release
- Basic selection functionality
- Multiple selection styles
- Custom row content support
- Per-item color customization
- Comprehensive demo app
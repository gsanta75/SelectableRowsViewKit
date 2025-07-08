import SwiftUI

/// A view that displays a collection of selectable rows with customizable selection indicators.
///
/// `SelectionRowsView` provides a flexible way to display lists of selectable items with various
/// visual styles for selection indicators. It supports both single and multiple selection modes,
/// custom row content, and different selection indicator styles.
///
/// ## Basic Usage
///
/// ```swift
/// @StateObject private var viewModel = SelectionViewModel<String>()
/// @State private var items = ["Item 1", "Item 2", "Item 3"]
///
/// SelectionRowsView(viewModel: viewModel, elements: $items)
/// ```
///
/// ## Custom Row Content
///
/// ```swift
/// SelectionRowsView(viewModel: viewModel, elements: $items) { item, isSelected in
///     HStack {
///         Image(systemName: "star")
///         Text(item)
///             .font(.headline)
///         Spacer()
///     }
///     .foregroundColor(isSelected ? .blue : .primary)
/// }
/// ```
///
/// ## Selection Styles
///
/// ```swift
/// SelectionRowsView(viewModel: viewModel, elements: $items)
///     .selectorStyle(.checkbox)
///     .colorItemSelectionProvider { item in
///         item.hasPrefix("Important") ? .red : .blue
///     }
/// ```
public struct SelectionRowsView<Element: Hashable, RowContent: View>: View {
    
    /// The view model that manages the selection state.
    @ObservedObject public var viewModel: SelectionViewModel<Element>
    
    /// The binding to the array of elements to display.
    @Binding public var elements: [Element]
    
    /// The environment selection style.
    @Environment(\.selectionIndicator) private var selectionIndicator
    
    /// The environment color provider for selection indicators.
    @Environment(\.colorItemSelectionProvider) private var colorItemProvider
    
    @Environment(\.selectorColor) private var color

    /// The closure that provides the content for each row.
    let rowContentProvider: (Element, _ isSelected: Bool) -> RowContent

    /// Creates a selection rows view with custom row content.
    ///
    /// - Parameters:
    ///   - viewModel: The view model that manages selection state.
    ///   - elements: A binding to the array of elements to display.
    ///   - rowContent: A closure that creates the content for each row.
    ///     The closure receives the element and its selection state.
    public init(
        viewModel: SelectionViewModel<Element>,
        elements: Binding<[Element]>,
        @ViewBuilder rowContent: @escaping (Element, _ isSelected: Bool) -> RowContent
    ) {
        self.viewModel = viewModel
        self._elements = elements
        self.rowContentProvider = rowContent
    }
    
    public var body: some View {
        ForEach(elements, id: \.self) { element in
            let indicatorColor: Color? = color ?? getIndicatorColor(for: element)
            let isSelected = viewModel.isSelected(element)
            let selectionAction = { viewModel.updateSelection(element) }
            
            switch selectionIndicator {
            case .checkmark:
                rowContentProvider(element, isSelected)
                    .checkmarkSelection(
                        isSelected: isSelected,
                        color: indicatorColor,
                        onSelectionChange: selectionAction
                    )
            case .checkbox:
                rowContentProvider(element, isSelected)
                    .checkboxSelection(
                        isSelected: isSelected,
                        color: indicatorColor,
                        onSelectionChange: selectionAction
                    )
            case .toggle:
                rowContentProvider(element, isSelected)
                    .toggleSelection(
                        isSelected: isSelected,
                        color: indicatorColor,
                        onSelectionChange: selectionAction
                    )
            case .tapOnElement, .none:
                rowContentProvider(element, isSelected)
                    .tapSelection(
                        isSelected: isSelected,
                        color: indicatorColor,
                        onSelectionChange: selectionAction
                    )
            }

        }
        .onDelete(perform: deleteItems)
        .onMove(perform: moveItems)
    }
    
    /// Gets the color for the selection indicator of the specified item.
    ///
    /// - Parameter item: The item to get the color for.
    /// - Returns: The color to use for the selection indicator, or `nil` for default color.
    private func getIndicatorColor(for item: Element) -> Color? {
        guard let provider = self.colorItemProvider else {
            return nil
        }
        
        return provider(item)
    }
    
    /// Handles the deletion of items.
    ///
    /// - Parameter indexSet: The indices of the items to delete.
    private func deleteItems(at indexSet: IndexSet) {
        elements.remove(atOffsets: indexSet)
    }
    
    /// Handles the movement of items.
    ///
    /// - Parameters:
    ///   - source: The source indices of the items to move.
    ///   - destination: The destination index for the items.
    private func moveItems(from source: IndexSet, to destination: Int) {
        elements.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Default Row Content

extension SelectionRowsView where RowContent == DefaultRowContent<Element> {
    
    /// Creates a selection rows view with default row content.
    ///
    /// The default content displays the string representation of each element,
    /// with selected items shown in blue color.
    ///
    /// - Parameters:
    ///   - viewModel: The view model that manages selection state.
    ///   - elements: A binding to the array of elements to display.
    public init(
        viewModel: SelectionViewModel<Element>,
        elements: Binding<[Element]>
    ) {
        self.viewModel = viewModel
        self._elements = elements
        self.rowContentProvider = { element, isSelected in
            DefaultRowContent(element: element, isSelected: isSelected)
        }
    }
}

/// The default row content view that displays an element with basic styling.
///
/// This view is used when no custom row content is provided. It displays the
/// string representation of the element with different colors for selected and
/// unselected states.
public struct DefaultRowContent<Element>: View {
    /// The element to display.
    public let element: Element
    
    /// Whether the element is currently selected.
    public let isSelected: Bool
    
    @Environment(\.selectionIndicator) private var selectionIndicator

    /// Creates a default row content view.
    ///
    /// - Parameters:
    ///   - element: The element to display.
    ///   - isSelected: Whether the element is currently selected.
    public init(element: Element, isSelected: Bool) {
        self.element = element
        self.isSelected = isSelected
    }
    
    public var body: some View {
        if selectionIndicator != nil && selectionIndicator != .tapOnElement {
            Text("\(element)")
                .foregroundColor(.primary)
        } else {
            Text("\(element)")
        }
    }
}

import Foundation
import SwiftUI

/// A view model that manages the selection state of hashable elements.
///
/// ``SelectionViewModel`` provides functionality to track and manipulate the selection
/// of elements in both single and multiple selection modes.
///
/// ## Usage
///
/// ```swift
/// // Create a view model for multiple selection
/// @StateObject private var multipleSelectionViewModel = SelectionViewModel<String>()
///
/// // Create a view model for single selection
/// @StateObject private var singleSelectionViewModel = SelectionViewModel<String>(mode: .single)
///
/// // Create a view model for single selection with required selection
/// @StateObject private var forcedSingleSelectionViewModel = SelectionViewModel<String>(
///     mode: .single,
///     requireSelection: true
/// )
/// ```
///
/// ## Initial Selection
///
/// When using `requireSelection: true`, you should ensure an initial selection in your view:
///
/// ```swift
/// .onAppear {
///     if viewModel.requiresSelection && !viewModel.hasSelection && !items.isEmpty {
///         viewModel.updateSelection(items[0])
///     }
/// }
/// ```
@MainActor
public class SelectionViewModel<T: Hashable>: ObservableObject {
    
    /// Defines the selection behavior of the view model.
    public enum SelectionMode {
        /// Only one element can be selected at a time.
        case single
        /// Multiple elements can be selected simultaneously.
        case multiple
    }
    
    /// The set of currently selected elements.
    @Published public private(set) var selectedElements: Set<T> = []
    
    /// The selection mode that determines how many elements can be selected.
    private let selectionMode: SelectionMode
    
    /// Whether at least one element must always be selected (only applies to single selection mode).
    private let requireSelection: Bool
    
    /// Creates a new selection view model with the specified selection mode and requirements.
    ///
    /// - Parameters:
    ///   - mode: The selection mode to use. Defaults to `.multiple`.
    ///   - requireSelection: Whether at least one element must always be selected.
    ///     Only applies to `.single` mode. Defaults to `false`.
    public init(mode: SelectionMode = .multiple, requireSelection: Bool = false) {
        self.selectionMode = mode
        self.requireSelection = requireSelection
    }
    
    /// Checks if the specified element is currently selected.
    ///
    /// - Parameter element: The element to check.
    /// - Returns: `true` if the element is selected, `false` otherwise.
    public func isSelected(_ element: T) -> Bool {
        selectedElements.contains(element)
    }
    
    /// Updates the selection state of the specified element.
    ///
    /// In single selection mode:
    /// - If `requireSelection` is `false`: If the element is already selected, it will be deselected.
    /// - If `requireSelection` is `true`: The element cannot be deselected if it's currently selected.
    /// - If another element is selected, it will be replaced by the new element.
    ///
    /// In multiple selection mode:
    /// - If the element is selected, it will be deselected.
    /// - If the element is not selected, it will be added to the selection.
    ///
    /// - Parameter element: The element to update.
    public func updateSelection(_ element: T) {
        switch selectionMode {
        case .single:
            if isSelected(element) {
                // If require selection is enabled, don't allow deselection
                if requireSelection {
                    return
                }
                // Otherwise, deselect the element
                selectedElements.removeAll()
            } else {
                // Replace current selection with new element
                selectedElements = [element]
            }
        case .multiple:
            if isSelected(element) {
                selectedElements.remove(element)
            } else {
                selectedElements.insert(element)
            }
        }
    }
    
    /// Selects all provided elements.
    ///
    /// Note: This method works in both single and multiple selection modes.
    /// In single mode, only the first element will remain selected.
    ///
    /// - Parameter elements: The elements to select.
    public func selectAll(_ elements: [T]) {
        if selectionMode == .single {
            selectedElements = Set(elements.prefix(1))
        } else {
            selectedElements.formUnion(elements)
        }
    }
    
    /// Deselects all currently selected elements.
    ///
    /// Note: In single selection mode with `requireSelection` enabled,
    /// this method will have no effect.
    public func deselectAll() {
        if selectionMode == .single && requireSelection {
            // If require selection is true, we don't deselect all
            return
        }
        selectedElements.removeAll()
    }
    
    /// The number of currently selected elements.
    public var selectionCount: Int {
        selectedElements.count
    }
    
    /// Whether any elements are currently selected.
    public var hasSelection: Bool {
        !selectedElements.isEmpty
    }
    
    /// Whether the selection mode requires at least one element to be selected.
    public var requiresSelection: Bool {
        selectionMode == .single && requireSelection
    }
}

//
//  SelectionViewModel.swift
//  SelectableRowsView
//
//  Created by Giuseppe Santaniello on 03/07/25.
//


import Foundation
import SwiftUI

/// A view model that manages the selection state of hashable elements.
/// 
/// `SelectionViewModel` provides functionality to track and manipulate the selection
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
    
    /// Creates a new selection view model with the specified selection mode.
    /// 
    /// - Parameter mode: The selection mode to use. Defaults to `.multiple`.
    public init(mode: SelectionMode = .multiple) {
        self.selectionMode = mode
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
    /// - If the element is already selected, it will be deselected.
    /// - If another element is selected, it will be replaced by the new element.
    /// 
    /// In multiple selection mode:
    /// - If the element is selected, it will be deselected.
    /// - If the element is not selected, it will be added to the selection.
    /// 
    /// - Parameter element: The element to update.
    public func updateSelection(_ element: T) {
        if selectionMode == .single {
            if isSelected(element) {
                // If clicking on the only selected element, deselect it
                selectedElements.removeAll()
            } else {
                // Replace current selection with new element
                selectedElements = [element]
            }
        } else { // multiple
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
    /// In single mode, only the last element will remain selected.
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
    public func deselectAll() {
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
}
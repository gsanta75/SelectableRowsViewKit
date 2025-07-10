import SwiftUI

// MARK: - Selection Icon ViewModifier

/// A view modifier that positions a selection icon within a view based on alignment.
/// Used internally by other selection modifiers to consistently place indicators.
struct SelectionIconView<IconSelection: View>: ViewModifier {
    /// The icon view to display.
    let icon: IconSelection
    /// The alignment of the icon within the view.
    let alignment: SelectionIndicatorAlignment
    
    /// Creates a new selection icon view modifier.
    /// - Parameters:
    ///   - icon: The icon view to display.
    ///   - alignment: The alignment of the icon within the view.
    init(icon: IconSelection,
         alignment: SelectionIndicatorAlignment
    ) {
        self.icon = icon
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        HStack {
            switch alignment {
            case .leading:
                icon.padding(.trailing, 8)
                content
                Spacer()
            case .trailing:
                content
                Spacer()
                icon
            }
        }
    }
}

extension View {
    func withSelectionIconView<IconSelection: View>(
        _ icon: IconSelection,
        alignment: SelectionIndicatorAlignment = .trailing
    ) -> some View {
        modifier(SelectionIconView(icon: icon, alignment: alignment))
    }
}

// MARK: - CheckboxSelection

/// A view modifier that adds a checkbox selection indicator to a view.
/// Displays a filled or empty square icon that can be tapped to toggle selection.
struct CheckboxSelection: ViewModifier {
    /// Whether the item is currently selected.
    let isSelected: Bool
    /// The color to use for the selection indicator.
    let color: Color?
    /// The placement of the selection indicator on a row.
    let alignment: SelectionIndicatorAlignment
    /// The action to perform when the selection state changes.
    let onSelectionChange: () -> Void
    
    /// Creates a checkbox selection modifier.
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    init(isSelected: Bool,
         color: Color? = nil,
         alignment: SelectionIndicatorAlignment = .trailing,
         onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    func body(content: Content) -> some View {
        content
            .withSelectionIconView(iconForSelection(isSelected), alignment: alignment)
    }
    
    @ViewBuilder
    private func iconForSelection(_ isSelected: Bool) -> some View {
        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .imageScale(.large)
            .foregroundStyle(color ?? .accentColor)
            .onTapGesture {
                onSelectionChange()
            }
    }
}

// MARK: - CheckmarkSelection

/// A view modifier that adds a checkmark selection indicator to a view.
/// Displays a checkmark icon when selected, or an invisible placeholder when not selected.
struct CheckmarkSelection: ViewModifier {
    /// Whether the item is currently selected.
    let isSelected: Bool
    /// The color to use for the selection indicator.
    let color: Color?
    /// The action to perform when the selection state changes.
    let onSelectionChange: () -> Void
    /// The placement of the selection indicator on a row.
    let alignment: SelectionIndicatorAlignment
    
    /// Creates a checkmark selection modifier.
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    init(isSelected: Bool,
         color: Color? = nil,
         alignment: SelectionIndicatorAlignment = .trailing,
         onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    func body(content: Content) -> some View {
        content
            .withSelectionIconView(iconForSelection(isSelected), alignment: alignment)
    }
    
    @ViewBuilder
    private func iconForSelection(_ isSelected: Bool) -> some View {
        if isSelected {
            Image(systemName: "checkmark")
                .foregroundStyle(color ?? .accentColor)
        } else {
            Rectangle()
                .frame(width: 25, height: 25)
                .foregroundStyle(.background.opacity(0.001))
        }
    }
}

// MARK: - ToggleSelection

/// A view modifier that adds a toggle switch selection indicator to a view.
/// Displays a standard iOS toggle switch that reflects the selection state.
struct ToggleSelection: ViewModifier {
    /// Whether the item is currently selected.
    let isSelected: Bool
    /// The color to use for the selection indicator.
    let color: Color?
    /// The placement of the selection indicator on a row.
    let alignment: SelectionIndicatorAlignment
    /// The action to perform when the selection state changes.
    let onSelectionChange: () -> Void
    
    /// Creates a toggle selection modifier.
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    init(isSelected: Bool,
         color: Color? = nil,
         alignment: SelectionIndicatorAlignment = .trailing,
         onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    func body(content: Content) -> some View {
        content
            .withSelectionIconView(iconForSelection(isSelected), alignment: alignment)
    }
    
    @ViewBuilder
    private func iconForSelection(_ isSelected: Bool) -> some View {
        Toggle("", isOn: Binding(
            get: { isSelected },
            set: { _ in onSelectionChange() }
        ))
        .labelsHidden()
        .fixedSize()
        .toggleStyle(SwitchToggleStyle(tint: color ?? .accentColor))
    }
}

// MARK: - TapElementSelection

/// A view modifier that adds tap gesture selection to the element content without visual indicator.
/// Changes the element's color when selected and responds to tap gestures.
struct TapElementSelection: ViewModifier {
    /// Whether the item is currently selected.
    let isSelected: Bool
    /// The color to use for the element when selected.
    let color: Color?
    /// The action to perform when the selection state changes.
    let onSelectionChange: () -> Void
    
    /// Creates a tap element selection modifier.
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the element when selected. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    init(isSelected: Bool,
         color: Color? = nil,
         onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.onSelectionChange = onSelectionChange
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(isSelected ? color ?? .blue : .primary)
            .onTapGesture {
                onSelectionChange()
            }
    }
}

// MARK: - TapRowSelection

/// A view modifier that adds tap gesture selection to the entire row without visual indicator.
/// Changes the element's color when selected and responds to tap gestures on the entire row area.
struct TapRowSelection: ViewModifier {
    /// Whether the item is currently selected.
    let isSelected: Bool
    /// The color to use for the element when selected.
    let color: Color?
    /// The action to perform when the selection state changes.
    let onSelectionChange: () -> Void
    
    /// Creates a tap row selection modifier.
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the element when selected. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    init(isSelected: Bool,
         color: Color? = nil,
         onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.onSelectionChange = onSelectionChange
    }
    
    func body(content: Content) -> some View {
        HStack {
            content
                .foregroundColor(isSelected ? color ?? .blue : .primary)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelectionChange()
        }
    }
}

// MARK: - View Extensions

extension View {
    
    /// Applies a selection indicator to the view based on the specified selection type.
    ///
    /// This method serves as a unified entry point for applying different selection indicators
    /// to views, automatically handling the appropriate modifier based on the selection type.
    ///
    /// - Parameters:
    ///   - selectionIndicator: The type of selection indicator to apply.
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    /// - Returns: A view with the appropriate selection indicator applied.
    @ViewBuilder
    internal func withSelectionIndicator(
        _ selectionIndicator: SelectionIndicator,
        isSelected: Bool,
        color: Color? = nil,
        onSelectionChange: @escaping () -> Void
    ) -> some View {
        switch selectionIndicator {
        case .checkbox(let alignment):
            self.modifier(CheckboxSelection(
                isSelected: isSelected,
                color: color,
                alignment: alignment,
                onSelectionChange: onSelectionChange
            ))
        case .checkmark(let alignment):
            self.modifier(CheckmarkSelection(
                isSelected: isSelected,
                color: color,
                alignment: alignment,
                onSelectionChange: onSelectionChange
            ))
        case .toggle(let alignment):
            self.modifier(ToggleSelection(
                isSelected: isSelected,
                color: color,
                alignment: alignment,
                onSelectionChange: onSelectionChange
            ))
        case .tapOnElement:
            self.modifier(TapElementSelection(
                isSelected: isSelected,
                color: color,
                onSelectionChange: onSelectionChange
            ))
        case .tapOnRow:
            self.modifier(TapRowSelection(
                isSelected: isSelected,
                color: color,
                onSelectionChange: onSelectionChange
            ))
        }
    }
}

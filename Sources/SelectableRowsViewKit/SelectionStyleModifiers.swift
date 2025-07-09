import SwiftUI

// MARK: - Selection Icon ViewModifier
public struct SelectionIconView<IconSelection: View>: ViewModifier {
    public let icon: IconSelection
    public let alignment: SelectionIndicatorAlignment
    
    public init(icon: IconSelection,
                alignment: SelectionIndicatorAlignment
    ) {
        self.icon = icon
        self.alignment = alignment
    }
    
    public func body(content: Content) -> some View {
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
    public func withSelectionIconView<IconSelection: View>(
        _ icon: IconSelection,
        alignment: SelectionIndicatorAlignment = .trailing
    ) -> some View {
        modifier(SelectionIconView(icon: icon, alignment: alignment))
    }
}

// MARK: - CheckboxSelection

/// A view modifier that adds a checkbox selection indicator to a view.
public struct CheckboxSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The placement of the selection indicator on a row
    public let alignment: SelectionIndicatorAlignment

    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a checkbox style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                color: Color? = nil,
                alignment: SelectionIndicatorAlignment = .trailing,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
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
public struct CheckmarkSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// The placement of the selection indicator on a row
    public let alignment: SelectionIndicatorAlignment
    
    /// Creates a checkmark style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                color: Color? = nil,
                alignment: SelectionIndicatorAlignment = .trailing,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
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

/// A view modifier that adds a toggle selection indicator to a view.
public struct ToggleSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The placement of the selection indicator on a row
    public let alignment: SelectionIndicatorAlignment

    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a toggle style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - alignment: The placement of the selection indicator on a row
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                color: Color? = nil,
                alignment: SelectionIndicatorAlignment = .trailing,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.alignment = alignment
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
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

/// A view modifier that adds tap gesture selection without visual indicator on the element content.
public struct TapElementSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the element selected.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a tap element selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the element when selected. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                color: Color? = nil,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
        content
            .foregroundColor(isSelected ? color ?? .blue : .primary)
            .onTapGesture {
                onSelectionChange()
            }
    }
}

// MARK: - TapRowSelection

/// A view modifier that adds tap gesture selection without visual indicator on the entire row.
public struct TapRowSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the element selected.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a tap row selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the element when selected. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                color: Color? = nil,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.color = color
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
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
    
    @ViewBuilder
    public func rowItemForSelection(
        selectionIndicator: SelectionIndicator,
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

import SwiftUI

/// A view modifier that adds a checkbox selection indicator to a view.
public struct CheckboxStyleSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a checkbox style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
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
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .imageScale(.large)
                .foregroundStyle(color ?? .accentColor)
                .onTapGesture {
                    onSelectionChange()
                }
        }
    }
}

/// A view modifier that adds a checkmark selection indicator to a view.
public struct CheckmarkStyleSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a checkmark style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
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
            
            Spacer()
            
            Button {
                onSelectionChange()
            } label: {
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(color ?? .accentColor)
                } else {
                    Rectangle()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.background.opacity(0.001))
                }
            }
            .buttonStyle(.plain)
        }
    }
}

/// A view modifier that adds a toggle selection indicator to a view.
public struct ToggleStyleSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The color to use for the selection indicator.
    public let color: Color?
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a toggle style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
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
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { isSelected },
                set: { _ in onSelectionChange() }
            ))
            .tint(color)
        }
    }
}

/// A view modifier that adds tap gesture selection without visual indicator.
public struct TapStyleSelection: ViewModifier {
    /// Whether the item is currently selected.
    public let isSelected: Bool
    
    /// The action to perform when the selection state changes.
    public let onSelectionChange: () -> Void
    
    /// Creates a tap style selection modifier.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    public init(isSelected: Bool,
                onSelectionChange: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.onSelectionChange = onSelectionChange
    }
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                onSelectionChange()
            }
    }
}

// MARK: - View Extensions

extension View {
    /// Adds a checkbox selection indicator to the view.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    /// - Returns: A view with a checkbox selection indicator.
    public func checkboxSelection(
        isSelected: Bool,
        color: Color? = nil,
        onSelectionChange: @escaping () -> Void
    ) -> some View {
        self.modifier(CheckboxStyleSelection(
            isSelected: isSelected,
            color: color,
            onSelectionChange: onSelectionChange
        ))
    }
    
    /// Adds a checkmark selection indicator to the view.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    /// - Returns: A view with a checkmark selection indicator.
    public func checkmarkSelection(
        isSelected: Bool,
        color: Color? = nil,
        onSelectionChange: @escaping () -> Void
    ) -> some View {
        self.modifier(CheckmarkStyleSelection(
            isSelected: isSelected,
            color: color,
            onSelectionChange: onSelectionChange
        ))
    }
    
    /// Adds a toggle selection indicator to the view.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - color: The color to use for the selection indicator. Pass `nil` to use the default color.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    /// - Returns: A view with a toggle selection indicator.
    public func toggleSelection(
        isSelected: Bool,
        color: Color? = nil,
        onSelectionChange: @escaping () -> Void
    ) -> some View {
        self.modifier(ToggleStyleSelection(
            isSelected: isSelected,
            color: color,
            onSelectionChange: onSelectionChange
        ))
    }
    
    /// Adds tap gesture selection without visual indicator.
    ///
    /// - Parameters:
    ///   - isSelected: Whether the item is currently selected.
    ///   - onSelectionChange: The action to perform when the selection state changes.
    /// - Returns: A view with tap gesture selection.
    public func tapSelection(
        isSelected: Bool,
        onSelectionChange: @escaping () -> Void
    ) -> some View {
        self.modifier(TapStyleSelection(
            isSelected: isSelected,
            onSelectionChange: onSelectionChange
        ))
    }
}

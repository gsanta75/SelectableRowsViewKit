import SwiftUI

// MARK: - Conditional View Modifier

extension View {
    /// Conditionally applies a view modifier based on a boolean condition.
    ///
    /// This modifier allows you to apply transformations to a view only when a certain condition is met.
    ///
    /// - Parameters:
    ///   - condition: The boolean condition that determines whether to apply the transformation.
    ///   - transform: The transformation to apply to the view when the condition is true.
    /// - Returns: The transformed view if the condition is true, otherwise the original view.
    @ViewBuilder
    public func `if`<Content: View>(_ condition: Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Selector Style Environment

extension View {
    /// Sets the selector style for selection indicators within `SelectionRowsView`.
    ///
    /// This modifier allows you to specify the visual style used for selection indicators
    /// (checkmark, checkbox, or toggle) in a `SelectionRowsView`.
    ///
    /// - Parameter style: The selector style to use, or `nil` to use default tap behavior.
    /// - Returns: A view that applies the specified selector style to the environment.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// SelectionRowsView(viewModel: viewModel, elements: $items)
    ///     .selectorStyle(.checkbox)
    /// ```
    public func selectorStyle(_ style: SelectorToggleStyle.SelectorStyle?) -> some View {
        self.environment(\.selectorStyle, style)
    }
}

private struct SelectorStyleKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: SelectorToggleStyle.SelectorStyle? = nil
}

extension EnvironmentValues {
    var selectorStyle: SelectorToggleStyle.SelectorStyle? {
        get { self[SelectorStyleKey.self] }
        set { self[SelectorStyleKey.self] = newValue }
    }
}

// MARK: - Color Item Selection Provider

private struct ColorItemSelectionProviderKey: EnvironmentKey {
    static let defaultValue: (@Sendable (AnyHashable) -> Color?)? = nil
}

extension EnvironmentValues {
    var colorItemSelectionProvider: (@Sendable (AnyHashable) -> Color?)? {
        get { self[ColorItemSelectionProviderKey.self] }
        set { self[ColorItemSelectionProviderKey.self] = newValue }
    }
}

extension View {
    /// Sets the color provider for selection indicators within `SelectionRowsView`.
    ///
    /// Use this modifier to customize the color of selection indicators (checkmark, checkbox, toggle tint)
    /// for individual items in a `SelectionRowsView`. The provider function is called for each item
    /// to determine its indicator color.
    ///
    /// - Parameter provider: A closure that takes an element and returns an optional `Color`.
    ///   - If the closure returns a specific `Color`, that color is used for the item's indicator.
    ///   - If the closure returns `nil`, the indicator inherits its color from the environment.
    /// - Returns: A view that applies the specified color provider to the environment.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// SelectionRowsView(viewModel: viewModel, elements: $numbers)
    ///     .colorItemSelectionProvider { number in
    ///         number % 2 == 0 ? .blue : .red
    ///     }
    /// ```
    public func colorItemSelectionProvider<E: Hashable>(_ provider: @escaping @Sendable (E) -> Color?) -> some View {
        let typeErasedSendableProvider: (@Sendable (AnyHashable) -> Color?) = { @Sendable anyItemFromRowView in
            guard let specificItem = anyItemFromRowView.base as? E else {
                #if DEBUG
                print("DEBUG: Type mismatch in colorItemSelectionProvider. Expected \(E.self), got \(type(of: anyItemFromRowView.base)).")
                #endif
                return nil
            }
            return provider(specificItem)
        }
        return self.environment(\.colorItemSelectionProvider, typeErasedSendableProvider)
    }
}

extension View {
    /// Sets a uniform color for all selection indicators within `SelectionRowsView`.
    ///
    /// This modifier allows you to specify a single color that will be applied to all
    /// selection indicators (checkmark, checkbox, toggle tint) in a `SelectionRowsView`.
    /// This provides a quick way to theme all indicators with the same color.
    ///
    /// - Parameter color: The color to apply to all selection indicators, or `nil` to use default colors.
    /// - Returns: A view that applies the specified color to all selection indicators in the environment.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// SelectionRowsView(viewModel: viewModel, elements: $items)
    ///     .selectorColor(.green)
    /// ```
    ///
    /// ## Notes
    ///
    /// - This modifier sets a uniform color for all items. For per-item color customization, use `colorItemSelectionProvider(_:)` instead.
    /// - When both `selectorColor` and `colorItemSelectionProvider` are used, the item-specific provider takes precedence.
    /// - For toggle style indicators, this color is applied as the tint color.
    /// - For checkmark and checkbox styles, this color is applied as the foreground color.
    public func selectorColor(_ color: Color?) -> some View {
        self.environment(\.selectorColor, color)
    }
}

/// Environment key for storing the uniform selector color.
///
/// This key is used internally to pass the selector color through the SwiftUI environment
/// to `SelectionRowsView` components. The default value is `nil`, which allows
/// selection indicators to use their default system colors.
private struct SelectorColorKey: EnvironmentKey {
    /// The default value when no selector color is specified in the environment.
    static let defaultValue: Color? = nil
}

/// Extension to add selector color support to the SwiftUI environment.
///
/// This extension provides access to the uniform selector color through the
/// environment values system, enabling `SelectionRowsView` components to
/// retrieve and apply the specified color to their selection indicators.
extension EnvironmentValues {
    /// The uniform color to apply to all selection indicators.
    ///
    /// When set to a specific color, all selection indicators within the environment
    /// will use this color. When `nil`, indicators use their default system colors.
    ///
    /// This property is automatically managed by the `selectorColor(_:)` view modifier
    /// and should not be accessed directly in most cases.
    var selectorColor: Color? {
        get { self[SelectorColorKey.self] }
        set { self[SelectorColorKey.self] = newValue }
    }
}

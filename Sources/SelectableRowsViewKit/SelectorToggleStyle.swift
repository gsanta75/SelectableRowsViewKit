//
//  SelectorToggleStyle.swift
//  SelectableRowsView
//
//  Created by Giuseppe Santaniello on 03/07/25.
//


import SwiftUI

/// A custom toggle style that provides different visual representations for selection indicators.
/// 
/// `SelectorToggleStyle` offers three different styles for displaying selection state:
/// - **Checkmark**: Shows a checkmark icon when selected
/// - **Checkbox**: Shows a filled or empty square checkbox
/// - **Toggle**: Shows a standard iOS toggle switch
/// 
/// ## Usage
/// 
/// ```swift
/// Toggle("Select Item", isOn: $isSelected)
///     .toggleStyle(SelectorToggleStyle(style: .checkmark, color: .blue))
/// ```
public struct SelectorToggleStyle: ToggleStyle {
    
    /// The visual style options for the selection indicator.
    public enum SelectorStyle: String, CaseIterable, Identifiable, Sendable {
        /// A checkmark icon that appears when selected.
        case checkmark
        /// A checkbox that shows filled when selected, empty when not.
        case checkbox
        /// A standard toggle switch.
        case toggle
        
        public var id: Self { self }
        
        /// The human-readable title for the style.
        public var title: String {
            switch self {
            case .checkmark: return "Checkmark"
            case .checkbox: return "Checkbox"
            case .toggle: return "Toggle"
            }
        }
    }
    
    /// The visual style to use for the toggle.
    let style: SelectorStyle
    
    /// The color to apply to the selection indicator. If `nil`, uses the default color.
    let color: Color?

    /// Creates a new selector toggle style.
    /// 
    /// - Parameters:
    ///   - style: The visual style to use for the toggle.
    ///   - color: The color to apply to the selection indicator. Pass `nil` to use the default color.
    public init(style: SelectorStyle, color: Color? = nil) {
        self.style = style
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Group {
                switch style {
                case .checkmark:
                    Button {
                        configuration.isOn.toggle()
                    } label: {
                        if configuration.isOn {
                            Image(systemName: "checkmark")
                        } else {
                            Rectangle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.background.opacity(0.001))
                        }
                    }
                    .buttonStyle(.plain)
                case .checkbox:
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .imageScale(.large)
                        .onTapGesture {
                            configuration.isOn.toggle()
                        }
                case .toggle:
                    Toggle("", isOn: configuration.$isOn)
                }
            }
            .if(color != nil && style != .toggle) { view in
                view.foregroundStyle(color!)
            }
            .if(color != nil && style == .toggle) { view in
                view.tint(color!)
            }
        }
    }
}

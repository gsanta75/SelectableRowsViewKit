//
//  ContentView.swift
//  SelectableRowsViewDemo
//
//  Created by Giuseppe Santaniello on 03/07/25.
//

import SwiftUI
import SelectableRowsViewKit

struct ContentView: View {
    
    // MARK: - View Models
    @StateObject private var personViewModelSelection = SelectionViewModel<Person>()
    @StateObject private var fruitsViewModelSelection = SelectionViewModel<Fruits>(mode: .single)
    @StateObject private var numbersViewModelSelection = SelectionViewModel<Int>()
    @StateObject private var happinessViewModelSelection = SelectionViewModel<HappinessLevel>(mode: .single)
    
    // MARK: - Data
    @State private var persons: [Person] = Person.mockData
    @State private var fruits: [Fruits] = Fruits.allCases
    @State private var numbers = [1, 2, 3, 4, 5]
    @State private var happiness: [HappinessLevel] = HappinessLevel.allCases
    
    var body: some View {
        List {
            // MARK: - Persons Section (Default Style)
            Section {
                SelectionRowsView(
                    viewModel: personViewModelSelection,
                    elements: $persons
                )
            } header: {
                Text("Persons (Default Style)")
            } footer: {
                Text("Tap to select/deselect. Multiple selection enabled.")
            }
    
            // MARK: - Happiness Section (Custom Row Content)
            Section {
                SelectionRowsView(
                    viewModel: happinessViewModelSelection,
                    elements: $happiness,
                    rowContent: happinessRow
                )
            } header: {
                Text("Happiness (Custom Content)")
            } footer: {
                Text("Single selection mode with custom row content.")
            }
    
            // MARK: - Fruits Section (Checkbox Style)
            Section {
                SelectionRowsView(
                    viewModel: fruitsViewModelSelection,
                    elements: $fruits)
                ) { item, _ in
                    Text(item.description)
                        .foregroundStyle(.black)
                }
                .selectorStyle(.checkbox)
                .foregroundStyle(.orange)
            } header: {
                Text("Fruits (Checkbox Style)")
            } footer: {
                Text("Single selection with checkbox indicators.")
            }
            
            // MARK: - Numbers Section (Toggle Style with Custom Colors)
            Section {
                SelectionRowsView(
                    viewModel: numbersViewModelSelection,
                    elements: $numbers
                ) { item, _ in
                    Text(item.description)
                }
                .selectorStyle(.toggle)
                .colorItemSelectionProvider { (item: Int) in
                    item % 2 == 0 ? .brown : .green
                }
            } header: {
                Text("Numbers (Toggle Style)")
            } footer: {
                Text("Multiple selection with toggle switches. Even numbers are brown, odd numbers are green.")
            }
            
            // MARK: - Selection Summary
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    selectionSummary(title: "Persons", count: personViewModelSelection.selectionCount)
                    selectionSummary(title: "Fruits", count: fruitsViewModelSelection.selectionCount)
                    selectionSummary(title: "Numbers", count: numbersViewModelSelection.selectionCount)
                    selectionSummary(title: "Happiness", count: happinessViewModelSelection.selectionCount)
                }
            } header: {
                Text("Selection Summary")
            }
        }
        .navigationTitle("SelectableRowsView Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Clear All") {
                    personViewModelSelection.deselectAll()
                    fruitsViewModelSelection.deselectAll()
                    numbersViewModelSelection.deselectAll()
                    happinessViewModelSelection.deselectAll()
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func happinessRow(for item: HappinessLevel, itemSelected: Bool) -> some View {
        HStack {
            Text(item.description)
                .foregroundColor(itemSelected ? .pink : .black)
            Spacer()
            if itemSelected {
                Text(item.statusIcon)
                    .font(.title2)
            }
        }
    }
    
    @ViewBuilder
    private func selectionSummary(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text("\(count) selected")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Demo Data Models

enum Fruits: String, CaseIterable, Identifiable {
    case apple
    case banana
    case orange
    case grape
    case strawberry
    
    var id: Self { self }
}

extension Fruits: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

struct Person: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let surname: String
    let age: Int
}

extension Person: CustomStringConvertible {
    var description: String {
        "\(name) \(surname), \(age)"
    }
}

extension Person {
    static let mockData: [Person] = [
        .init(name: "Alice", surname: "Anderson", age: 25),
        .init(name: "Bob", surname: "Brown", age: 30),
        .init(name: "Charlie", surname: "Clark", age: 22),
        .init(name: "David", surname: "Davis", age: 27),
        .init(name: "Emma", surname: "Evans", age: 28),
        .init(name: "Frank", surname: "Foster", age: 35)
    ]
}

enum HappinessLevel: String, CaseIterable, Identifiable {
    case veryHappy
    case happy
    case neutral
    case sad
    case verySad
    
    var id: Self { self }
}

extension HappinessLevel: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension HappinessLevel {
    var statusIcon: String {
        switch self {
        case .veryHappy: return "😄"
        case .happy: return "😊"
        case .neutral: return "😐"
        case .sad: return "😔"
        case .verySad: return "😭"
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

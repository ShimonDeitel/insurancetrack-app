import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Policy? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.provider.isEmpty ? "Untitled" : item.provider)
                                    .font(Theme.headline)
                                    .foregroundStyle(.primary)
                                Text(String(format: "%.2f", item.premium)).font(Theme.caption).foregroundStyle(Theme.accent2)
                                Text(item.renewalDate.formatted(date: .abbreviated, time: .omitted)).font(Theme.caption).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .accessibilityIdentifier("row_\(item.id.uuidString)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Insurancetrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Policy
    var onSave: (Policy) -> Void

    init(item: Policy?, onSave: @escaping (Policy) -> Void) {
        _draft = State(initialValue: item ?? Policy())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Provider", text: $draft.provider)
                    .accessibilityIdentifier("field_provider")
                TextField("Type", text: $draft.policyType)
                    .accessibilityIdentifier("field_policyType")
                TextField("Premium", value: $draft.premium, format: .number)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_premium")
                DatePicker("Renewal Date", selection: $draft.renewalDate, displayedComponents: .date)
                    .accessibilityIdentifier("field_renewalDate")
                TextField("Notes", text: $draft.notes)
                    .accessibilityIdentifier("field_notes")
            }
            .navigationTitle("Policy")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}

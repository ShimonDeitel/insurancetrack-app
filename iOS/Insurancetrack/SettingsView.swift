import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("showMetric") private var showMetric = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Enable Reminders", isOn: $notificationsEnabled)
                        .accessibilityIdentifier("toggleReminders")
                    Toggle("Show Numeric Summary", isOn: $showMetric)
                        .accessibilityIdentifier("toggleMetric")
                }
                Section("Insurancetrack Pro") {
                    if purchases.isPurchased {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            Task { await purchases.purchase() }
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/insurancetrack-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/insurancetrack-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("doneButton")
                }
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(PurchaseManager())
}

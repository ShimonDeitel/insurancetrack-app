import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent2)
                    Text("Insurancetrack Pro")
                        .font(Theme.largeTitle)
                        .foregroundStyle(.primary)
                    Text("Renewal alerts and premium-change history per policy")
                        .font(Theme.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPurchased { dismiss() }
                        }
                    } label: {
                        Text(purchases.products.first?.displayPrice ?? "$2.99")
                            .font(Theme.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    .accessibilityIdentifier("purchaseButton")
                    .padding(.horizontal, 32)
                    Button("Not Now") { dismiss() }
                        .accessibilityIdentifier("dismissPaywallButton")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}

#Preview {
    PaywallView().environmentObject(PurchaseManager())
}

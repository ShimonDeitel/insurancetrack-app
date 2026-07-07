import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Policy] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("insurancetrack_items.json")
    }()

    init() {
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Policy) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Policy) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Policy) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Policy].self, from: data) {
            items = decoded
        } else {
            items = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static let seedData: [Policy] = [
        Policy(provider: "Provider 1", policyType: "Policytype 1", premium: 10.0, renewalDate: Date().addingTimeInterval(-86400), notes: "Notes 1"),
        Policy(provider: "Provider 2", policyType: "Policytype 2", premium: 20.0, renewalDate: Date().addingTimeInterval(-172800), notes: "Notes 2"),
        Policy(provider: "Provider 3", policyType: "Policytype 3", premium: 30.0, renewalDate: Date().addingTimeInterval(-259200), notes: "Notes 3")
    ]
}

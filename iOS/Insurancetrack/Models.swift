import Foundation

struct Policy: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var provider: String
    var policyType: String
    var premium: Double
    var renewalDate: Date
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), provider: String = "", policyType: String = "", premium: Double = 0, renewalDate: Date = Date(), notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.provider = provider
        self.policyType = policyType
        self.premium = premium
        self.renewalDate = renewalDate
        self.notes = notes
    }
}

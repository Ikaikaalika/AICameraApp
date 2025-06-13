import Foundation

struct RestoredPhoto: Identifiable {
    let id: UUID
    let url: URL
    
    init(id: UUID = UUID(), url: URL) {
        self.id = id
        self.url = url
    }
}

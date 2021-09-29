/// - Details view model responsible for storage of data for the specific details view
import Foundation

struct DetailsVM {
    var reposName: String
    var ownerName: String
    var reposDescription: String
    var ownersEmail: String
    var id: Int
    var canBeAdded: Bool = true
}

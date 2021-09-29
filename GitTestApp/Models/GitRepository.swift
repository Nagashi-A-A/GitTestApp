/// - Struct used for decode purpose of repository JSON data from GIT
import Foundation

public struct GitRepository: Decodable {
    var id: Int             // Repository id
    var name: String        // Repository name
    var fullName: String    // Repository full name
    var info: String        // Repository info
    var owner: Owner        // Repository owner
    
    /// Key decoding strategy for snake case
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case info = "description"
        case owner
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        info = try container.decodeIfPresent(String.self, forKey: .name) ?? "Info is not specified."
        owner = try container.decode(Owner.self, forKey: .owner)
    }
}
/// - Struct used for decode purpose of owner's JSON data from GIT
public struct Owner: Decodable {
    var login: String       // Owner's login name
    
    init(login: String){
        self.login = login
    }
}

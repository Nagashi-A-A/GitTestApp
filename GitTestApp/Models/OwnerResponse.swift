/// - Struct used for decode of Git repository owner's data
import Foundation

public struct OwnerResponse: Decodable {
    var name: String    //Owner's full name
    var email: String   //Owner's email
    var login: String!  //Owner's login name
    
    public enum CodingKeys: String, CodingKey {
        case name
        case email
        case login
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decode(String.self, forKey: .login)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Not specified"
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? "Not specified"
    }
}

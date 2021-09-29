/// - Struct used for decode purpose of JSON data from GIT
import Foundation

struct GitReposResponse: Decodable {
    var items: [GitRepository]
}

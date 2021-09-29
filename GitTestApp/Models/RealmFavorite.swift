/// - Realm Object Model for saving favorites purpose.
import Foundation
import RealmSwift

class RealmFavorite: Object {
    @Persisted var repName: String! = ""            //Repository name
    @Persisted var repDescription: String! = ""     //Repository description
    @Persisted var repOwner: String! = ""           //Name of repository owner
    @Persisted var ownerEmail: String! = ""         //Email of repository owner
    @Persisted (primaryKey: true) var id: Int! = 0  // Id of repository
    
    convenience init(id: Int,
                     repName: String,
                     info: String,
                     owner: String,
                     email: String) {
        self.init()
        self.repDescription = info
        self.repOwner = owner
        self.ownerEmail = email
        self.id = id
    }
}

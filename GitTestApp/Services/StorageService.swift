/// - Service responsible for long term storage of user chosen favorites
import Foundation
import RealmSwift

protocol  StorageProtocol {
    func saveFavorites(list: [RealmFavorite])   //Method responsible for background preservation of user's favorites
    func getFavorites() -> [RealmFavorite]      //Method responsible for favorites extraction from database
    func deleteFavorite(forKey: Int) -> Bool    //Method responsible for deletion of chosen favorite element
}

final class StorageService {
    private var storage: StorageProtocol
    var container = [RealmFavorite]()    //Container for temporary storage of favorites data
    let notification: Notification       //Notification responsible for favorites table view reloading
    static let shared = StorageService() //Shared StorageService for general app purpose
    
    init() {
        self.storage = try! Realm()
        notification = Notification(name: Notification.Name("reloadViewData"))
    }
    /// Method responsible for addition of chosen favorite to storage container
    /// - Parameter id: Int parameter used to specify repository ID
    /// - Parameter repName: String parameter containing repository name
    /// - Parameter info: String parameter containing repository description
    /// - Parameter owner: String parameter containing repository owner's name
    /// - Parameter email: String parameter containing repository owner's email address
    func addFavoriteToContainer(id: Int,
                                repName: String,
                                info: String,
                                owner: String,
                                email: String) -> Bool{
        for (_, item) in container.enumerated() {
            if item.id == id{
                return false
            }
        }
        let item = RealmFavorite()
        item.repName = repName
        item.repDescription = info
        item.repOwner = owner
        item.ownerEmail = email
        item.id = id
        container.append(item)
        return true
    }
    /// - Method responsible for uploading of favorites data, contained in database
    func uploadFromStorage(){
        self.container = storage.getFavorites()
    }
    /// - Method responsible for updating database with new data from container
    func updateStorage(){
        storage.saveFavorites(list: container)
    }
    /// - Method responsible for deletion of chosen favorite from container and database
    /// - Parameter id: Int parameter used to specify repository ID chosen for deletion
    func deleteFavoriteFromStorage(id: Int){
        for (index, item) in container.enumerated() {
            if item.id == id{
                container.remove(at: index)
                _ = storage.deleteFavorite(forKey: id)
            }
        }
    }
}
/// - Extension of Realm database to conform StorageProtocol
extension Realm: StorageProtocol {
    /// - Method responsible for deletion of chosen favorite from container and database
    /// - Parameter list: Array of RealmFavorite objects specified for preservation
    func saveFavorites(list: [RealmFavorite]) {
        let realm = try! Realm()
        try! realm.write{
            for item in list {
                realm.add(item)
            }
        }
    }
    /// - Method responsible for deletion of chosen favorite from database
    /// - Parameter id: Int parameter used to specify repository ID chosen for deletion
    func deleteFavorite(forKey: Int) -> Bool {
        let realm = try! Realm()
        do {
            try realm.write{
                realm.delete(self.objects(RealmFavorite.self).filter("id == \(forKey)"))
            }
            return true
            } catch {
                return false
            }
    }
    /// - Method responsible for extraction of preserved favorites from database
    func getFavorites() -> [RealmFavorite] {
        let realm = try! Realm()
        var result = [RealmFavorite]()
        let request = realm.objects(RealmFavorite.self)
        for item in request {
            result.append(item)
        }
        return result
    }
}

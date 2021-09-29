/// - View model for SearchViewController
import Foundation

protocol  SearchVMProtocol {
    var searchResults: [GitRepository] { get set }  //Search Results container with search data
    var searchCompleted: Notification { get set }   //Notification used to update table view with search results
    var ownerParsed: Notification { get set }       //Notification used to update details view with search result about owner
    var ownerResult: (String, String) { get set }   //Repository Owner's data
    var itemIndex: Int { get set }                  //Index data for table didSelectRowAt method
    
    func createRequestForRepository(name: String)   //Get request for repository search
    func createRequestForOwner(name: String)        //Get request for owner's search
}

class SearchVM: SearchVMProtocol {
    var searchResults = [GitRepository]()
    var searchCompleted: Notification
    var ownerParsed: Notification
    var ownerResult: (String, String) = ("Nil", "Nil")
    var itemIndex: Int = 0
    
    init() {
        let searchNotification = Notification.Name(rawValue: "searchCompleted")
        let ownerNotification = Notification.Name(rawValue: "ownerParsed")
        self.searchCompleted = Notification(name: searchNotification)
        self.ownerParsed = Notification(name: ownerNotification)
    }
    /// Method responsible for creating Git repository search request
    /// - Parameter name: String parameter used to specify key word of request
    func createRequestForRepository(name: String) {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(name)%20in:name,description&per_page=30")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
        "Accept": "application/vnd.github.v3+json"
        ]
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let data = data{
                do{
                    let apiResponse = try JSONDecoder().decode(GitReposResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = apiResponse.items
                        NotificationCenter.default.post(self.searchCompleted)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    /// Method responsible for creating search request for Git repository owner's data
    /// - Parameter name: String parameter used to specify key word of request (Owner's name)
    func createRequestForOwner(name: String){
        let url = URL(string: "https://api.github.com/users/\(name)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
        "Accept": "application/vnd.github.v3+json"
        ]
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let data = data{
                do{
                    let apiResponse = try JSONDecoder().decode(OwnerResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.ownerResult = (apiResponse.name, apiResponse.email)
                        NotificationCenter.default.post(self.ownerParsed)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
/// Extension of String used for testing purpose of request key word format
extension String {
    var isLatin: Bool {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lower = "abcdefghijklmnopqrstuvwxyz"

        for c in self.map({ String($0) }) {
            if upper.contains(c) || lower.contains(c) {
                return true
            }
        }
        return false
    }

    var isCyrillic: Bool {
        let upper = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЪЭЮЯ"
        let lower = "абвгдеёжзийклмнопрстуфхцчшщьъэюя"

        for c in self.map({ String($0) }) {
            if upper.contains(c) || lower.contains(c) {
                return true
            }
        }
        return false
    }

    var isBothLatinAndCyrillic: Bool {
        return self.isLatin && self.isCyrillic
    }
}

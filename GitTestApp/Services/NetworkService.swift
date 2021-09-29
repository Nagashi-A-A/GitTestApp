//
//  NetworkService.swift
//  GitTestApp
//
//  Created by Anton Yaroshchuk on 19.08.2021.
//

import Foundation

class NetworkService {
    var reposResults = [GitRepository]()
    var ownerResult: (String, String) = ("Nil", "Nil")
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
                        self.reposResults = apiResponse.items
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func createRequestForOwner(name: String){
        let url = URL(string: "https://api.github.com/users/\(name)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
        "Accept": "application/vnd.github.v3+json"
        ]
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data{
                do{
                    let apiResponse = try JSONDecoder().decode(OwnerResponse.self, from: data)
                    self.ownerResult = (apiResponse.name, apiResponse.email)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func bindResult(values: [GitRepository]){
        self.reposResults = values
    }
}

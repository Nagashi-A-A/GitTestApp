/// - View for repository search and search results.
import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchVM: SearchVMProtocol = SearchVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository Search"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadResults), name: searchVM.searchCompleted.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(passOwnerDetails), name: searchVM.ownerParsed.name, object: nil)
    }
    /// - Method for search initialization.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchController.searchBar.text{
            if !text.isCyrillic && !text.isBothLatinAndCyrillic{
                searchVM.createRequestForRepository(name: text)
            }
        }
    }
    /// - Method responsible for segue to DetailsViewController with info about author of chosen repository.
    @objc func passOwnerDetails(){
        let reposName = searchVM.searchResults[searchVM.itemIndex].fullName
        let ownerName = searchVM.ownerResult.0
        let info = searchVM.searchResults[searchVM.itemIndex].info
        let ownersEmail = searchVM.ownerResult.1
        let id = searchVM.searchResults[searchVM.itemIndex].id
        let vc = DetailsViewController()
        vc.detailsVM = DetailsVM(reposName: reposName,
                                 ownerName: ownerName,
                                 reposDescription: info,
                                 ownersEmail: ownersEmail,
                                 id: id)
        vc.detailsVM?.canBeAdded = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchVM.searchResults[indexPath.row].fullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchName = searchVM.searchResults[indexPath.row].owner.login
        searchVM.createRequestForOwner(name: searchName)
        searchVM.itemIndex = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVM.searchResults.count
    }
    
    @objc func reloadResults(){
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

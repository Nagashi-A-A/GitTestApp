/// - View for user's Favorites repository list.
import UIKit

class FavoritesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        StorageService.shared.uploadFromStorage()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: StorageService.shared.notification.name, object: nil)
    }
    
    @objc func updateData(){
        self.tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        cell.textLabel?.text = StorageService.shared.container[indexPath.row].repName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageService.shared.container.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.detailsVM = DetailsVM(reposName: StorageService.shared.container[indexPath.row].repName,
                                 ownerName: StorageService.shared.container[indexPath.row].repOwner,
                                 reposDescription: StorageService.shared.container[indexPath.row].repDescription,
                                 ownersEmail: StorageService.shared.container[indexPath.row].ownerEmail,
                                 id: StorageService.shared.container[indexPath.row].id)
        vc.detailsVM?.canBeAdded = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                StorageService.shared.container.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
}

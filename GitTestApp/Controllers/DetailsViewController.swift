/// - View with details of author's info for chosen repository.
import UIKit

class DetailsViewController: UIViewController {
    var detailsVM: DetailsVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to Favorites",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addToFavorites))
        let rect = CGRect(x: 0,
                          y: 0,
                          width: view.layer.bounds.width - 20,
                          height: view.layer.bounds.height/2)
        
        let infoView = DetailsView(frame: rect)
        infoView.center = view.center
        infoView.fillInfo(repo: detailsVM!.reposName,
                          info: detailsVM!.reposDescription,
                          owner: detailsVM!.ownerName,
                          email: detailsVM!.ownersEmail)
        view.addSubview(infoView)
        if !detailsVM!.canBeAdded{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    /// - Method used to add favorites to the storage container
    @objc func addToFavorites(){
        if StorageService.shared.addFavoriteToContainer(id: detailsVM!.id,
                                                        repName: detailsVM!.reposName,
                                                        info: detailsVM!.reposDescription,
                                                        owner: detailsVM!.ownerName,
                                                        email: detailsVM!.ownersEmail){
            let ac = UIAlertController(title: "Added to Favorites", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default))
            present(ac, animated: true)
            NotificationCenter.default.post((StorageService.shared.notification))
        } else {
            let ac = UIAlertController(title: "Already in Favorites", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default))
            present(ac, animated: true)
        }
    }
}

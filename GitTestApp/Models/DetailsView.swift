/// - Detail's view created programmaticaly
import UIKit

class DetailsView: UIView {
    var reposName: UILabel?     //Repository name label
    var reposDesc: UILabel?     //Repository description label
    var ownerName: UILabel?     //Owner's name label
    var ownerEmail: UILabel?    //Owner's email label
    /// - View initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.backgroundColor = backColor
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        setupView()
        setupConstraints()
    }
    /// - View setup method
    func setupView(){
        let textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) //Text color for all label's
        reposName = UILabel()
        reposName!.translatesAutoresizingMaskIntoConstraints = false
        reposName!.textColor = textColor
        reposName!.textAlignment = .center
        reposName!.font = UIFont.systemFont(ofSize: 20)
        reposName!.numberOfLines = 0
        self.addSubview(reposName!)
        
        reposDesc = UILabel()
        reposDesc!.translatesAutoresizingMaskIntoConstraints = false
        reposDesc!.textColor = textColor
        reposDesc!.textAlignment = .center
        reposDesc!.numberOfLines = 0
        reposDesc!.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(reposDesc!)
        
        ownerName = UILabel()
        ownerName!.translatesAutoresizingMaskIntoConstraints = false
        ownerName!.textColor = textColor
        ownerName!.textAlignment = .center
        ownerName!.numberOfLines = 0
        ownerName!.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(ownerName!)
        
        ownerEmail = UILabel()
        ownerEmail!.translatesAutoresizingMaskIntoConstraints = false
        ownerEmail!.textColor = textColor
        ownerEmail!.textAlignment = .center
        ownerEmail!.numberOfLines = 0
        ownerEmail!.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(ownerEmail!)
    }
    /// - Method for constraints setup
    func setupConstraints(){
        NSLayoutConstraint.activate([
            //Repository name labels's constraints
            reposName!.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 20),
            reposName!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            reposName!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //Repository description labels's constraints
            reposDesc!.topAnchor.constraint(equalTo: reposName!.layoutMarginsGuide.bottomAnchor, constant: 15),
            reposDesc!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            reposDesc!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //Owner's name labels's constraints
            ownerName!.topAnchor.constraint(equalTo: reposDesc!.layoutMarginsGuide.bottomAnchor, constant: 20),
            ownerName!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            ownerName!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //Owner's email labels's constraints
            ownerEmail!.topAnchor.constraint(equalTo: ownerName!.layoutMarginsGuide.bottomAnchor, constant: 15),
            ownerEmail!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            ownerEmail!.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// - Method for label's description setup
    func fillInfo(repo: String, info: String, owner: String, email: String){
        reposName?.text = "Repository name:\n \(repo)"
        reposDesc?.text = "Description:\n \(info)"
        ownerName?.text = "Owner:\n \(owner)"
        ownerEmail?.text = "Owner's Email:\n \(email)"
    }
}

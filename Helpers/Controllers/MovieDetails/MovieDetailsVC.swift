
import UIKit
import Cosmos
import Kingfisher

class MovieDetailsVC: UIViewController{
    
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var voteAverageCosmosView: CosmosView!
    @IBOutlet weak var rateCosmosView: CosmosView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    var reviewsArray = [ReviewResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosViewsSetup()
        cellsRegister()
        getMovieDetails()
        getReviews()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
    }
    
    func cellsRegister() {
        reviewsTableView.registerCellNib(cellType: ReviewsTableViewCell.self)
    }
    
    func cosmosViewsSetup() {
        rateCosmosView.settings.fillMode = .precise
        voteAverageCosmosView.settings.fillMode = .precise
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "star") {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reviewsArray[section].author
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemRed
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeue() as ReviewsTableViewCell
        cell.reviewLabel.text = reviewsArray[indexPath.row].content
        return cell
    }
}

extension MovieDetailsVC {
    func getMovieDetails() {
        Hud.show()
        TestAPI.shared.getMovieDetails { (result) in
            switch result {
            case .success(let response):
                let imageString = response?.belongsToCollection?.posterPath ?? ""
                let urlString = "https://image.tmdb.org/t/p/w500/" + imageString
                let imageURL = URL(string: urlString)
                self.movieImageView.kf.setImage(with: imageURL)
                self.movieNameLabel.text = response?.title ?? ""
                self.movieDate.text = response?.releaseDate ?? ""
                self.moviePopularity.text = String(response?.popularity ?? 0)
                self.movieDescription.text = response?.overview ?? ""
                self.voteAverageCosmosView.rating = response?.voteAverage ?? 0
            case .failure(let error):
                ShowAlert.alertUser(styleController: .alert, messageTitle: "Warning!", messageBody: error.rawValue, actionTitleOne: "OK", actionStyleOne: .default, actionTitleTwo: "", actionStyleTwo: .default, viewController: self)
            }
        }
    }
    
    func getReviews() {
        TestAPI.shared.getReviews() { (result) in
            Hud.dismiss()
            switch result {
            case .success(let response):
                self.reviewsArray = response?.results ?? []
                self.reviewsTableView.reloadData()
            case .failure(let error):
                ShowAlert.alertUser(styleController: .alert, messageTitle: "Warning!", messageBody: error.rawValue, actionTitleOne: "OK", actionStyleOne: .default, actionTitleTwo: "", actionStyleTwo: .default, viewController: self)
            }
        }
    }
}


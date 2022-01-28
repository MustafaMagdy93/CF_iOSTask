
import UIKit
import Kingfisher

class HomeVC: UIViewController{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var favoritedCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!

    static var popularMoviesArray = [Results]()
    var topMovies = false
    var favoritedArray = [Results]()
    var refreshControl = UIRefreshControl()
    let nowPlayingCollectionViewflowLayout = UICollectionViewFlowLayout()
    let favoritedCollectionViewflowLayout = UICollectionViewFlowLayout()
    static var movieId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
       cellsRegister()
        getPopularMovies()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        mainView.addSubview(refreshControl) // not required when using UITableViewController
        collectionViewSetUp()
    }
    
    func collectionViewSetUp() {
        nowPlayingCollectionViewflowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2.8, height: 300)
        nowPlayingCollectionViewflowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        nowPlayingCollectionViewflowLayout.scrollDirection = .horizontal
        popularCollectionView.collectionViewLayout = nowPlayingCollectionViewflowLayout
        
        favoritedCollectionViewflowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2.8, height: 100)
        favoritedCollectionViewflowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        favoritedCollectionViewflowLayout.scrollDirection = .horizontal
        favoritedCollectionView.collectionViewLayout = favoritedCollectionViewflowLayout

    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table vie
        getPopularMovies()
        refreshControl.endRefreshing() // End Refreshing
    }

    func cellsRegister() {
        favoritedCollectionView.registerCellNib(cellType: FavouriteCollectionViewCell.self)
        popularCollectionView.registerCellNib(cellType: PopularCell.self)
    }
  

}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularCollectionView:
            return HomeVC.popularMoviesArray.count
            
        default:
            return favoritedArray.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularCollectionView:
            let cell = popularCollectionView.dequeue(indexPath: indexPath) as PopularCell
            let imageString = HomeVC.popularMoviesArray[indexPath.row].posterPath
            let urlString = "https://image.tmdb.org/t/p/w500/" + imageString
            let imageURL = URL(string: urlString)
            cell.image.kf.setImage(with: imageURL)
            cell.moviesNameLabel.text = HomeVC.popularMoviesArray[indexPath.row].title
            cell.favoriteButton = {
                if cell.favButton.currentImage == UIImage(systemName: "star") {
                    cell.favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    self.favoritedArray.append(HomeVC.popularMoviesArray[indexPath.row])
                    self.favoritedCollectionView.reloadData()
                } else {
                    cell.favButton.setImage(UIImage(systemName: "star"), for: .normal)
                    if let index = self.favoritedArray.firstIndex(of: HomeVC.popularMoviesArray[indexPath.row]) {
                        self.favoritedArray.remove(at: index)
                        self.favoritedCollectionView.reloadData()
                        }
                }
            }
            return cell
            
        default:
            let cell = favoritedCollectionView.dequeue(indexPath: indexPath) as FavouriteCollectionViewCell
            let imageString = favoritedArray[indexPath.row].posterPath
            let urlString = "https://image.tmdb.org/t/p/w500/" + imageString
            let imageURL = URL(string: urlString)
            cell.image.kf.setImage(with: imageURL)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case popularCollectionView:
            HomeVC.movieId = HomeVC.popularMoviesArray[indexPath.row].id
            let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "MovieDetailsVC") as! MovieDetailsVC
            print(indexPath.row)
            present(view, animated: true, completion: nil)
        default:
            return
        }
    }
}

extension HomeVC {
    func getPopularMovies() {
        Hud.show()
        TestAPI.shared.getPopularMovies() { (result) in
            Hud.dismiss()
                switch result {
                case .success(let response):
                    HomeVC.popularMoviesArray = response?.results ?? []
                    self.popularCollectionView.reloadData()
                    self.favoritedCollectionView.reloadData()
                    print("response is : \(HomeVC.popularMoviesArray)")

                case .failure(let error):
                    ShowAlert.alertUser(styleController: .alert, messageTitle: "Warning!", messageBody: error.rawValue, actionTitleOne: "OK", actionStyleOne: .default, actionTitleTwo: "", actionStyleTwo: .default, viewController: self)
                }
            }
        }
}

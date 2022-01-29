
import UIKit
import Kingfisher
import SwiftlyCache

class HomeVC: UIViewController{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var favoritedCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!

    static var popularMoviesArray = [Results]()
    var moviesPerPage = 3
    var limit = 3
    var paginationPopularMoviesArray = [Results]()
    var topMovies = false
    var favoritedArray = [Results]()
    var refreshControl = UIRefreshControl()
    let nowPlayingCollectionViewflowLayout = UICollectionViewFlowLayout()
    let favoritedCollectionViewflowLayout = UICollectionViewFlowLayout()
    let resultsCache = MultiCache<[Results]>()
    
    static var movieId: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        checkCach()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellsRegister()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        mainView.addSubview(refreshControl) // not required when using UITableViewController
        collectionViewSetUp()

    }
    
    func checkCach() {
        if let object = resultsCache.object(forKey: "movies") {
//            print("当前movies是:\(object)")
            ifDataCached(cachedObject: object)
        } else {
            getPopularMovies()
        }
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
            return paginationPopularMoviesArray.count
            
        default:
            return favoritedArray.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularCollectionView:
            let cell = popularCollectionView.dequeue(indexPath: indexPath) as PopularCell
            let imageString = paginationPopularMoviesArray[indexPath.row].posterPath
            let urlString = "https://image.tmdb.org/t/p/w500/" + imageString
            let imageURL = URL(string: urlString)
            cell.image.kf.setImage(with: imageURL)
            cell.moviesNameLabel.text = paginationPopularMoviesArray[indexPath.row].title
            cell.favoriteButton = {
                if cell.favButton.currentImage == UIImage(systemName: "star") {
                    cell.favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    self.favoritedArray.append(self.paginationPopularMoviesArray[indexPath.row])
                    self.favoritedCollectionView.reloadData()
                } else {
                    cell.favButton.setImage(UIImage(systemName: "star"), for: .normal)
                    if let index = self.favoritedArray.firstIndex(of: self.paginationPopularMoviesArray[indexPath.row]) {
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
            HomeVC.movieId = paginationPopularMoviesArray[indexPath.row].id
            let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "MovieDetailsVC") as! MovieDetailsVC
            print(indexPath.row)
            present(view, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == popularCollectionView {
            Hud.show()
            if (scrollView.contentOffset.x + scrollView.frame.size.width) >= (scrollView.contentSize.width) {
                setPaginationMovies(moviesPerPage: moviesPerPage)
            }
        }
        Hud.dismiss()
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
                    self.resultsCache.set(forKey: "movies", value: HomeVC.popularMoviesArray)

                    self.limit = HomeVC.popularMoviesArray.count
                    for i in 0..<3 {
                        self.paginationPopularMoviesArray.append(HomeVC.popularMoviesArray[i])
                    }
                    self.popularCollectionView.reloadData()
                    print("response is : \(HomeVC.popularMoviesArray)")

                case .failure(let error):
                    ShowAlert.alertUser(styleController: .alert, messageTitle: "Warning!", messageBody: error.rawValue, actionTitleOne: "OK", actionStyleOne: .default, actionTitleTwo: "", actionStyleTwo: .default, viewController: self)
                }
            }
        }
    
    func ifDataCached(cachedObject: [Results]) {
//        if let object = cache.object(forKey: "movies") {
        print("cashed")
            HomeVC.popularMoviesArray = cachedObject
            self.limit = HomeVC.popularMoviesArray.count
            for i in 0..<3 {
                self.paginationPopularMoviesArray.append(HomeVC.popularMoviesArray[i])
//            }
            popularCollectionView.reloadData()
        }
    }
    
    func setPaginationMovies(moviesPerPage: Int) {
        if moviesPerPage >= limit {
            return
        } else if moviesPerPage >= limit - 3 {
            for i in moviesPerPage..<limit {
                paginationPopularMoviesArray.append(HomeVC.popularMoviesArray[i])
            }
            self.moviesPerPage += 3
        } else {
            for i in moviesPerPage..<moviesPerPage + 3 {
                paginationPopularMoviesArray.append(HomeVC.popularMoviesArray[i])
            }
            self.moviesPerPage += 3
        }
        popularCollectionView.reloadData()
    }
}

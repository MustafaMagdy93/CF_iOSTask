import UIKit
import Kingfisher

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData = [Results]()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    func updateUI(){
        tableView.registerCellNib(cellType: SearchContentCell.self)
        searchBar.delegate = self
        filteredData = HomeVC.popularMoviesArray
        searchBar.searchTextField.textColor = .white
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SearchContentCell
        let imageString = filteredData[indexPath.row].posterPath
        let urlString = "https://image.tmdb.org/t/p/w500/" + imageString
        let imageURL = URL(string: urlString)
        cell.img.kf.setImage(with: imageURL)
        cell.name.text = filteredData[indexPath.row].title
        cell.date.text = filteredData[indexPath.row].releaseDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
}

extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
    
    func filterContentForSearchText(searchText: String) {
        if searchText != "" {
            filteredData = HomeVC.popularMoviesArray.filter { name in
                return   name.title.lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }else {
            filteredData = HomeVC.popularMoviesArray
        }
        self.tableView.reloadData()
    }
}

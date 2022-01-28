
import UIKit


class PopularCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var moviesNameLabel: UILabel!
    
    var favoriteButton : (()-> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBAction func favoritePressed(_ sender: UIButton) {
        favoriteButton?()
    }
}

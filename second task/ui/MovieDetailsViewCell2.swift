//import UIKit
//
//class MovieDetailsViewCell: UITableViewCell {
//
//    @IBOutlet var myTitle : UILabel!
//    @IBOutlet var myImage : UIImageView!
//    @IBOutlet var myOverView : UILabel!
//
//    static let identifier = "MovieDetailsViewCell"
//
//    func mySetup(with movie: MovieModel) {
//        myTitle.text = movie.collectionName
//        myOverView.text = movie.longDescription
//
//        guard let url = URL(string: movie.artworkUrl100!) else { return  }
//
//        let imageData = try? Data(contentsOf: url)
//        myImage.image = UIImage(data: imageData!)
//
//    }
//
//    static func nib() -> UINib{
//        return UINib(nibName: "MovieDetailsViewCell", bundle: nil)
//    }
//
//}

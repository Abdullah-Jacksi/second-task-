//
//  MyCollectionViewCell.swift
//  second task
//
//  Created by abd on 21/01/2022.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var myLabel : UILabel!
    @IBOutlet var myImageView : UIImageView!
    private var task: URLSessionDataTask?
    
    static let identifier = "MyCollectionViewCell"
    var imageCache = ImageCache()
    
    func setup(with movie: MovieModel) {
        myLabel.text = movie.collectionName
        if let url = movie.artworkUrl100 {
            loadImage(url:url)
        }
        
        
    }
    func loadImage(url:String) {
        if task == nil {
            task = myImageView.downloadImage(imageUrl: url)
        }
    }
    
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myLabel.text = nil
        myImageView.image = nil
        task?.cancel()
        task = nil
    }
}

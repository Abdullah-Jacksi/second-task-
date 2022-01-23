//
//  MovieDetailView.swift
//  second task
//
//  Created by abd on 22/01/2022.
//

import UIKit

class MovieDetailView : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myTB : UITableView!
    
    var MyMovieModel : MovieModel!
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTB.register(MovieDetailsTableViewCell.nib(), forCellReuseIdentifier: MovieDetailsTableViewCell.identifier)
        myTB.delegate = self
        myTB.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMovieItem))
        //(id:movies[indexPath.row].collectionId ?? 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.identifier, for: indexPath) as! MovieDetailsTableViewCell
        cell.mySetup(with: MyMovieModel)
        return cell
    }
    
    @objc func deleteMovieItem (){
        print("delete item === \(id)")
        let alert = UIAlertController(title: "Are You Sure?", message: "Are you sure want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                UserDefaults.standard.set(self.id, forKey: "\(self.id)")
                print("okay deleted successfully")
                self.navigationController?.popViewController(animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("default")
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

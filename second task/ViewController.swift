//
//  ViewController.swift
//  second task
//
//  Created by abd on 21/01/2022.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var emptyMessage:UILabel!
    
    var movies = [MovieModel]()
    var networkBrain = NetworkBrain()
    var mySearchText : String = ""
    var categories : [String] = ["all","movie","podcast","music"]
    var myCategory : String = "all"
    var mySavedCategory : String = ""
    let pickerView = UIPickerView(frame:
                                    CGRect(x: 0, y: 50, width: 260, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        searchBar.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        mySavedCategory = UserDefaults.standard.string(forKey: "myCategory") ?? "all"
        getSavedCategory()
       

    
    }
    
    
    @IBAction func changeSearchCategory(_ sender: Any) {
                
        let alert = UIAlertController(title: "Choose Category", message: "\n\n\n\n\n\n", preferredStyle: .alert)
    
                
        alert.view.addSubview(pickerView)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                UserDefaults.standard.set(self.myCategory, forKey: "myCategory")
                print("okay")
                
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
    func getMovies (searchText:String , myCategory:String) {
        mySavedCategory = UserDefaults.standard.string(forKey: "myCategory") ?? "all"
        print("mySavedCategory = \(mySavedCategory)")
        movies = []
        emptyMessage.text = ""
        networkBrain.getMoviesList(searchText: searchText, media: myCategory) { [weak self] res  in
            switch (res){
            case.success(let data):
                self?.checkIfItemDeletedOrNot(data: data)
                print("movies.count")
                print(self?.movies.count ?? 0)
                if(data.count == 0){
                    self?.emptyMessage.text = "there is no results"
                }else{
                    print("data.count \(data.count)")
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(_):
                print(Error.self)
                return
            }
        }
    }
    
    func getMoreMovies (searchText:String) {
        print("networkBrain.offset \(networkBrain.offset)")
        networkBrain.offset = networkBrain.offset + 10
        networkBrain.getMoviesList(searchText: searchText, media: myCategory) { [weak self] res  in
            switch (res){
            case.success(let data):
                self?.checkIfItemDeletedOrNot(data: data)
//                self?.movies.append(contentsOf: data)
                print("more data count = \(data.count)")
                print("movies count = \(self?.movies.count)")
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(_):
                return
            }
        }
    }
    func checkIfItemDeletedOrNot(data:[MovieModel]){
        for i in (0 ..< data.count){
            if let id = data[i].collectionId{
                if (UserDefaults.standard.string(forKey: "\(id)")
                        == nil) {
                    self.movies.append(data[i])
                }else{
                    print("this item is deleted ")
                }
            }
        }
    }
}
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        mySearchText = searchText
        
        if(searchText.isEmpty){
            movies = []
            emptyMessage.text = "There is no content"
            collectionView.reloadData()
        }else{
            getMovies(searchText: mySearchText, myCategory: myCategory)
        }
    }
}

extension  ViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myCategory = categories[row]
    }
    func getSavedCategory(){
        print("mySavedCategory = \(mySavedCategory)")
        if !(mySavedCategory.isEmpty){
            for i in (0 ..< categories.count) {
               if (categories[i] == mySavedCategory) {
                pickerView.selectRow(i, inComponent: 0, animated: true)
               }
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.setup(with: movies[indexPath.row])
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == .phone &&
                UIDevice.current.orientation == UIDeviceOrientation.portrait){
            return CGSize(width: view.frame.width/1 - 5, height: 300)
        }else{
            return CGSize(width: view.frame.width/2 - 5, height: 300)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == movies.count - 2){
            getMoreMovies (searchText: mySearchText)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "MovieDetailView") as! MovieDetailView
        let nc = storyboard?.instantiateViewController(withIdentifier: "DestinationNavigationController") as! UINavigationController
    
        
        nc.pushViewController(vc, animated: true)

        vc.MyMovieModel = movies[indexPath.row]
        vc.id = movies[indexPath.row].collectionId ?? 0
        
        nc.modalPresentationStyle = .fullScreen
        
        
        self.present(nc, animated: true, completion: nil)

    }
    
    
    
   
}


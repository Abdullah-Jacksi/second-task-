import Foundation


class NetworkBrain {
    
    var offset : Int = 0
    
    func getMoviesList (searchText:String, media:String, compation: @escaping (Result<[MovieModel],Error> ) -> Void){
        let stringURL : String! = "https://itunes.apple.com/search?term=\(searchText)&media=\(media)&limit=10&offset=\(offset)"
        
        guard let stringURL = stringURL else {
            print("there is an error in url")
            return
        }
        
        let url = URL(string: stringURL)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url! , completionHandler: { data, response, error in
            if  error != nil {
                print("there is an error in get dat \(error!.localizedDescription)")
                compation(.failure(error!))
                return
            }
            
            if let safeData = data {
                
                do{
                    print(safeData)
                    let result = try JSONDecoder().decode(MoviesModel.self, from: safeData)
                    compation(.success(result.results))
                    
                }catch{
                    print("there is an error : \(error)")
                }
                
            }
            
        })
        
        task.resume()
        
    }
    
}

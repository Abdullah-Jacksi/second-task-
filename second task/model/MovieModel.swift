//
//  MovieModel.swift
//  second task
//
//  Created by abd on 21/01/2022.
//

import Foundation

struct MoviesModel: Decodable {
    
    let results: [MovieModel]

}

struct MovieModel : Decodable {
    let collectionId : Int?
    let collectionName : String?
    let longDescription : String?
    let artworkUrl100 : String?
}

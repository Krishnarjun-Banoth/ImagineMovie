//
//  Movie.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import Foundation
import UIKit


struct Movie: Codable, Hashable{
  var id : String
  var schedulededFilmId : String
  var cinemaId : String? = ""
  var hasFutureSessions : Bool
  var title: String
  var synopsis: String
  var synopsisAlt: String
  var trailerUrl: String
  
  
  enum CodingKeys: String, CodingKey {
    case id = "ID"
    case schedulededFilmId = "ScheduledFilmId"
    case cinemaId = "CinemaId"
    case hasFutureSessions = "HasFutureSessions"
    case title = "Title"
    case synopsis = "Synopsis"
    case synopsisAlt = "SynopsisAlt"
    case trailerUrl = "TrailerUrl"
    
    
  }
}

struct MovieList: Codable, Hashable{
  var movieList : [Movie]
  enum CodingKeys: String, CodingKey {
    case movieList = "movie_list"
  }
  
}


struct MovieParams: Codable, Hashable {
  var userId : Int = 2496
  var deviceId: String = "C59CA619-DC90-4194-85E8-D1F20D9644EF"
  var cinemaId: String = "Lakeville"
  
  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case deviceId = "device_id"
    case cinemaId = "cinema_id"
  }
}

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
  
  func cacheImage(urlString: String){
    guard let url = URL(string: urlString) else{
      return
    }
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
      self.image = imageFromCache
      return
    }
    DispatchQueue.global().async {
      let data = try? Data(contentsOf: url)
      if let data = data {
        if let img = UIImage(data: data){
          DispatchQueue.main.async {
            imageCache.setObject(img, forKey: urlString as AnyObject)
            self.image = img
          }
        }
      }
    }
  }
}




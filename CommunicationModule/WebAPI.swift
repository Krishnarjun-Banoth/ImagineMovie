//
//  CommunicationModule.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class WebAPI {
  static let shared = WebAPI()
  
  private init()
  {
  }
  
  func downloadAllMovies(with urlStr: String){
    //create the url with URL
    guard let url = URL(string: urlStr) else {
      return
    }
    //create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    
    let parameters = MovieParams()
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
      request.httpBody = try encoder.encode(parameters)
    } catch {
      print(error.localizedDescription)
    }
    request.addValue(Constants.accessToken, forHTTPHeaderField: "AccessToken")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: request){(data, response, err) in
      guard let data = data else{
        return
      }
      if let jsonString = String(data: data, encoding: .utf8) {
        do {
          let decoder = JSONDecoder()
          let movies = try decoder.decode(MovieList.self, from: Data(jsonString.utf8))
          if urlStr == Constants.comingSoonURLString {
            DataProvider.shared.comingSoonMovies = Set(movies.movieList)
          }
          else{
            DataProvider.shared.inTheatresMovies = Set(movies.movieList)
          }
          DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didCompletedMoviesDownload, object: self)
          }
          
        } catch {
          print(error)
        }
      }
      
      }.resume()
  }
  
  func getImage(with urlString: String, completion:@escaping(UIImage)->()){
    let image = UIImage(named: "img1") //default image
    guard let url = URL(string: urlString) else{
      completion(image!)
      return
    }
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
      return completion(imageFromCache)
      
    }
    DispatchQueue.global().async {
      let data = try? Data(contentsOf: url)
      if let data = data {
        if let img = UIImage(data: data){
          imageCache.setObject(img, forKey: urlString as AnyObject)
          completion(img)
        }
      }
    }
  }
}


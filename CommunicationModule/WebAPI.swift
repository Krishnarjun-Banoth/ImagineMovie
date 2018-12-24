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
       
       
        request.addValue("1536898194", forHTTPHeaderField: "AccessToken")
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
}

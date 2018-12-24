//
//  Constants.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import Foundation



enum Constants {
    static let accessToken = "1536898194"
    static let baseURLString = "http://devemagine.thetunagroup.com/emagine3/api/"
    static let nowShowingURLString = Constants.baseURLString + "getMovieListAll"
    static let comingSoonURLString = Constants.baseURLString + "getComingSoon"
    static let imageBaseUrl = "https://connect.emagine-entertainment.com/CDN/media/entity/get/FilmPosterGraphic/"
}

var isComingSoonSelected = false

extension Notification.Name {
    static let didCompletedMoviesDownload = Notification.Name("didCompletedMovieDownload")
}

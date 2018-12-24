//
//  DataProvider.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import Foundation
import UIKit


class DataProvider {
    static let shared = DataProvider()
    
    private init()
    {
    }

    var comingSoonMovies = Set<Movie>()
    var inTheatresMovies = Set<Movie>()
   
}

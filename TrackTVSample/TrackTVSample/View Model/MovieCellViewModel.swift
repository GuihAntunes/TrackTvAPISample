//
//  MovieCellViewModel.swift
//  TrackTVSample
//
//  Created by Guilherme Antunes on 21/11/17.
//  Copyright © 2017 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit

struct MovieCellViewModel {
    let title : String
    let image : UIImage
    
    init(title : String, image : UIImage?) {
        self.title = title
        self.image = image ?? UIImage()
    }
    
    init(movie : Movie) {
        self.title = movie.title + " (\(movie.releaseYear))"
        self.image = UIImage() //make a request with movie.imageId
    }
    
}

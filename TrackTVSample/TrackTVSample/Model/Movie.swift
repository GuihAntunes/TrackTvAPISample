//
//  Movie.swift
//  TrackTVSample
//
//  Created by Guilherme Antunes on 21/11/17.
//  Copyright © 2017 Guilherme Antunes. All rights reserved.
//

import Foundation
import Freddy

struct Movie {
    
    var title : String
    var releaseYear : Int
    var imageId : String
    
    init(title : String, releaseYear : Int, imageId : String) {
        self.title = title
        self.releaseYear = releaseYear
        self.imageId = imageId
    }
    
    init() {
        self.title = ""
        self.releaseYear = 0
        self.imageId = ""
    }
    
}

extension Movie : JSONDecodable {
    public init(json: JSON) throws {
        self.title = try json.getString(at: "title")
        self.releaseYear = try json.getInt(at: "year")
        self.imageId = try json.getString(at: "ids","imdb")
    }
}

//
//  Title.swift
//  MovieFlex
//
//  Created by Warln on 20/03/22.
//

import UIKit

struct MovieTitleResponse: Codable {
    var results : [Title]
}

struct Title: Codable {
    var id: Int?
    var overview: String?
    var title: String?
    var original_title: String?
    var poster_path: String?
    var release_date: String?
    var video: Bool?
    var vote_average: Float?
    var popularity: Double?
    var media_type: String?
    
}


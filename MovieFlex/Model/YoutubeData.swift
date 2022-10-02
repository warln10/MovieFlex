//
//  YoutubeData.swift
//  MovieFlex
//
//  Created by Warln on 23/03/22.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: ID
}

// MARK: - ID
struct ID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}



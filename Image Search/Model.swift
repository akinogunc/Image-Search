//
//  Model.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

import Foundation

struct Response: Codable{
    let total: Int
    let totalHits: Int
    let hits: [Hit]
}

struct Hit: Codable{
    let collections: Int
    let comments: Int
    let downloads: Int
    let id: Int
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let largeImageURL: URL
    let likes: Int
    let pageURL: URL
    let previewHeight: Int
    let previewURL: URL
    let previewWidth: Int
    let type: String
    let tags: String
    let user: String
    let userImageURL: String
    let user_id: Int
    let views: Int
    let webformatHeight: Int
    let webformatURL: URL
    let webformatWidth: Int
}

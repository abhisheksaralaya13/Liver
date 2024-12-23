//
//  VideoData.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//


import Foundation

struct VideoData: Codable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let topic: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
}

struct VideoResponse: Codable {
    let videos: [VideoData]
}

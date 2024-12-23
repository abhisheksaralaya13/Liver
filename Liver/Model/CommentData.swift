//
//  Comment.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//

import Foundation

struct CommentData: Codable {
    let id: Int
    let name: String
    let profile_pic: String
    let text: String
}

struct CommentDataResponse: Codable {
    let comments: [CommentData]
}

//
//  Post.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 20.01.2023.
//

import Foundation

struct Post: Decodable {
    let id: String
    let createdAt: Int
    let text: String
    let imageUrl: String
    let user: User
    var fromNow: String?
    var comments: [Comment]?
    var hasLiked: Bool?
    var likesCount: Int
    
}



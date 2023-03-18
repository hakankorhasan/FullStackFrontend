//
//  User.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 29.01.2023.
//

import Foundation

struct User: Decodable {
    let id: String
    let fullName: String
    var isFollowing: Bool?
    var bio, profileImageUrl: String?
    var following, followers: [User]?
    var posts: [Post]?
    var isEditable: Bool?
}

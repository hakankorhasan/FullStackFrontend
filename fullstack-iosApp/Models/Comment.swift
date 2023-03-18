//
//  Comment.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 20.02.2023.
//

import Foundation

struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
}

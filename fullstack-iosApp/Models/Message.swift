//
//  Message.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 1.03.2023.
//

import Foundation

struct Message: Decodable {
    let id: Int
    let user, from, to: User
    var message: String
    var read: Bool
}

//
//  SocketIOManager.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 6.03.2023.
//

import Foundation

protocol SocketIOManager {
    
    func establishConnection()
    func closeConnection()
    func connectToChat(with name: String)
    func observerUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(message: String, username: String)
    func observeMessage(completionHandler: @escaping ([String: Any]) -> Void)
}

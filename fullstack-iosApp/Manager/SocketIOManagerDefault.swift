//
//  SocketIOManagerDefault.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 5.03.2023.
//

import Foundation
import SocketIO

class SocketIOManagerDefault: NSObject, SocketIOManager {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: URL(string: "http://localhost:1337")!)
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToChat(with name: String) {
        socket.emit("connectUser", name)
    }
    
    func observerUserList(completionHandler: @escaping ([[String : Any]]) -> Void) {
        socket.on("userList") { dataArray, _  in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
        
    }
    
    func send(message: String, username: String) {
        socket.emit("chatMessage", username, message)
    }
    
    func observeMessage(completionHandler: @escaping ([String : Any]) -> Void) {
        socket.on("newChatMessage") { dataArray, _ in
            
        }
    }
    
    
}

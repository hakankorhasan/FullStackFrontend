//
//  ViewController.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 7.03.2023.
//

import UIKit
import SocketIO



class ViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource{

    // SocketIO client
    let manager = SocketManager(socketURL: URL(string: "http://localhost:1337")!)
    var socket: SocketIOClient!
    
    var messages: [String] = []
    lazy var tableView: UITableView = {
            let tableView = UITableView(frame: view.bounds, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            // Diğer tableView ayarları
            return tableView
        }()
       
       
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         // Özelliklerin başlatılması
         socket = manager.defaultSocket
     }

     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         // Özelliklerin başlatılması
         socket = manager.defaultSocket
     }
    
    lazy var customIntputMessageView: CustomInputMessageView = {
        let cimv = CustomInputMessageView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 60))
        cimv.sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return cimv
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            customIntputMessageView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           // Setup UI components
           
           self.tableView.register(MessageCelll.self, forCellReuseIdentifier: "messageCell")
           view.addSubview(tableView)
           
           // Setup SocketIO
           socket = manager.defaultSocket
           socket.on(clientEvent: .connect) { data, ack in
               print("socket connected")
           }
           socket.on("chat message") { data, ack in
               if let msgText = data[0] as? String {
                   self.messages.append(msgText)
                   self.tableView.reloadData()
               }
           }
           socket.connect()
       }
    
    
    @objc func handleSendMessage() {
        if let msg = customIntputMessageView.textView.text {
            socket.emit("chat message", msg)
            customIntputMessageView.textView.text = ""
        }
    }
    
    deinit {
        socket.disconnect()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCelll
        cell.isUserInteractionEnabled = false
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            let message = messages[indexPath.row]
            // Calculate the height of the cell based on the message content
            let height = message.height(withConstrainedWidth: tableView.frame.width - 32, font: UIFont.systemFont(ofSize: 17))
            // Add some extra padding to the calculated height
            return height + 20
        
    }
       

}



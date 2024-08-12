//
//  FolkScrollDemoApp.swift
//  FolkScrollDemo
//
//  Created by Omar Rizwan on 8/10/24.
//

import SwiftUI

@main
struct FolkScrollDemoApp: App {
    @StateObject private var comm = Comm()
    init() {
        comm.connect()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(comm)
        }
    }
}

class Comm: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask!
    
    func connect() {
        let url = URL(string: "ws://localhost:4273/ws")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
        
        // Send establishing programs
        self.send("Claim boop blop")
    }
    func send(_ program: String) {
        let message = URLSessionWebSocketTask.Message.string(
            "Assert when websocket $chan is connected [list {this __seq} {\(program)}] with environment [list $chan [incr ::__seq]]"
        )
        webSocketTask.send(message) {_ in }
    }
    func didScroll(scrollOffset: CGPoint) {
        
    }
}

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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    comm.connect()
                }
                .environmentObject(comm)
        }
    }
}

class Comm: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask!
    
    init() {
        print("HELLO")
    }
    func connect() {
        let url = URL(string: "ws://localhost:4273/ws")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
        
        // Send establishing programs
        self.send("""
When the scroll offset y is /offsetY/ {
  Wish to draw text with x 100 y 100 text $offsetY
}
""")
    }
    func send(_ program: String) {
        let message = URLSessionWebSocketTask.Message.string(
            "Assert when websocket $chan is connected [list {this __seq} {\(program)}] with environment [list $chan [incr ::__seq]]"
        )
        webSocketTask.send(message) {err in if err != nil { print(err) }}
    }
    func hold(key: String, _ program: String) {
        let message = URLSessionWebSocketTask.Message.string(
            "Hold (non-capturing) (on folk-scroll-demo-app) {\(key)} {\(program)}"
        )
        webSocketTask.send(message) {err in if err != nil { print(err) }}
            
    }
    func didScroll(scrollOffset: CGPoint) {
        if (webSocketTask != nil) {
            self.hold(key: "scroll offset y",
                      "Claim the scroll offset y is \(scrollOffset.y)")
        }
    }
}

//
//  ScrollDemoApp.swift
//  ScrollDemo
//
//  Created by Omar Rizwan on 8/10/24.
//

import SwiftUI

@main
struct ScrollDemoApp: App {
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
        let url = URL(string: "ws://folk-live.local:4273/ws")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
        
        // Send establishing programs
        self.send("""
set phone 48700
When tag $phone has quad /q0/ & $phone has quad /q/ {
  # so the tag doesn't have to be visible to maintain the region:
  Hold phone quad { Claim $phone has quad $q }
  Wish $phone is outlined green
}

set im [image load "$::env(HOME)/folk-live/folk-images/out00.png"]
When $phone has region /r/ & the scroll offset y is /offsetY/ {
  lassign [region top [region move $r up [- ${offsetY}]px]] tx ty
  Wish to draw an image with center [list $tx $ty] \
    image $im radians [region angle $r] \
    scale [/ [region width $r] [::image_t width $im]] \
    crop [list 0. 0. 1.0 1.0]
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

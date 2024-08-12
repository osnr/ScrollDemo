//
//  ContentView.swift
//  FolkScrollDemo
//
//  Created by Omar Rizwan on 8/10/24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var comm: Comm
    @State private var scrollOffset = CGPoint()
    
    var body: some View {
        OffsetObservingScrollView(offset: $scrollOffset) {
            Image("picsew")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(alignment: .topLeading)
                .foregroundStyle(.tint)
                .scrollTargetLayout()

        }.onChange(of: scrollOffset, initial: true) { newValue, oldValue  in
            comm.didScroll(scrollOffset: newValue)
        }
    }
}

#Preview {
    ContentView()
}

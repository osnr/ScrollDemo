//
//  ContentView.swift
//  ScrollDemo
//
//  Created by Omar Rizwan on 8/10/24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var comm: Comm
    
    @State private var didTap: Bool = false
    @State private var scrollOffset = CGPoint()
    
    var body: some View {
        if !didTap {
            Button(action: {
                self.didTap = true
            }) {
               Image("tag-48700")
                    .interpolation(.none)
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
            }
        } else {
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
}

#Preview {
    ContentView()
}

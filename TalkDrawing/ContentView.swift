//
//  ContentView.swift
//  TalkDrawing
//
//  Created by Changjun Li on 2023/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // background
            Image("background")
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

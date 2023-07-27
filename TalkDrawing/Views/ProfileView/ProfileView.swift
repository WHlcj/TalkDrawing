//
//  ProfileView.swift
//  TalkDrawing
//
//  Created by Changjun Li on 2023/7/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
        
            VStack {
                Spacer()
                // 妙语生画logo
                Image("title")
                    .resizable()
                    .frame(width: 647, height: 195)
                    .padding(.leading, 100)
                Spacer()
                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

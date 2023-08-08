//
//  ChallengeCell.swift
//  TalkDrawing
//
//  Created by Changjun Li on 2023/7/29.
//

import SwiftUI

struct ChallengeCell: View {
    
    @Binding var path: NavigationPath
    let challenge: StoryChallengeModel
    
    var body: some View {
        Button {
            path.append(AppRouter.StoriesListView)
        } label: {
            VStack {
                ZStack {
                    Image(challenge.title)
                    Image(challenge.isLocked ? "imageLock" : "imageUlock")
                }
                Text(challenge.title)
                    .font(.system(size: 35).bold())
                    .foregroundColor(.orange)
            }
        }
        .disabled(challenge.isLocked ? true : false)
    }
}

struct ChallengeCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        let model = StoryChallengeModel(title: "童话寓言", age: .zeroToThree)
        ChallengeCell(path: $path, challenge: model)
    }
}

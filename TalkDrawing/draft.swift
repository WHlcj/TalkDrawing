import SwiftUI
import AVKit

struct VideoPlayerView: View {
    // 视频播放器
    @State private var player = AVPlayer()
    // 选定的暂停时间
    @State private var fixedSeekDuration: Double = 2.0
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .onAppear {
                    // 获取资源文件的 URL
                    if let videoURL = Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4") {
                        player = AVPlayer(url: videoURL)
                    }
                }
                .onTapGesture {
                    seekVideo()
                }
        }
    }
    
    private func seekVideo() {
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + fixedSeekDuration) {
            player.pause()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}

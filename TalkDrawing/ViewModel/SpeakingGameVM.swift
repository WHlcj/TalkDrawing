
import Foundation
import AVKit

class SpeakingGameVM: ObservableObject{
    
    /// 播放故事视频
    @Published var videoPlayer = AVPlayer()
    // 游戏模组
    @Published var model = createSpeakingGame()
    
    private static func createSpeakingGame() -> SpeakingGameModel {
        SpeakingGameModel()
    }
    
    
    /// 若为我的绘本，进入SpeakingShowcaseView后初始化视频
    func initVideoPlayer(story: Story) {
        // 获取资源文件的 URL
        if let videoURL = story.url {
            videoPlayer = AVPlayer(url: videoURL)
        } else {
            self.videoPlayer = AVPlayer()
        }
    }
    
}

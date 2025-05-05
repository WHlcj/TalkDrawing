
import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    
    @Published var videoPlayer = AVPlayer()
    @Published var voicePlayer = AVAudioPlayer()
    @Published var model = createStoryGame()

    private static func createStoryGame() -> StoryGameModel {
        StoryGameModel()
    }
    var challenges: [StoryChallenge] {
        self.model.challenges
    }
    
    var selectedChallenge: StoryChallenge?
    var selectedStory: Story?
    private var videoURL: URL?
    
    func chooseChallenge(challenge: StoryChallenge) {
        self.model.ChooseChallenge(challenge: challenge)
        self.selectedChallenge = challenge
    }
    
    func chooseStory(story: Story) {
        self.model.ChooseStory(story: story)
        self.selectedStory = story
        initVideoPlayer()
    }

    func initVideoPlayer() {
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
            if let videoURL = challenges[challengeIndex].stories[storyIndex].url {
                self.videoPlayer = AVPlayer(url: videoURL)
            } else {
                self.videoPlayer = AVPlayer()
            }
        }
    }
    
    func playVideo() {
        self.videoPlayer.play()
    }
    
    func stopVideo() {
        self.videoPlayer.pause()
    }
    
    func stopSound() {
        self.voicePlayer.stop()
    }
    
    func playSound(_ sound: String) {
        if sound == "" {
            self.voicePlayer.play()
            return
        }
        
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            self.voicePlayer = try AVAudioPlayer(contentsOf: url)
            self.voicePlayer.play()
        } catch let error {
            print("[StoryGameVM] playSound failed with error: \(error)")
        }
    }
    
    func finishedGame() {
        self.model.FinishStory()
    }
    
}


import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    static let shared = StoryGameVM()
    
    @Published var videoPlayer = AVPlayer()
    @Published var voicePlayer = AVAudioPlayer()
    @Published private(set) var model = createStoryGame()

    private static func createStoryGame() -> StoryGameModel {
        StoryGameModel()
    }
    
    var challenges: [StoryChallenge] {
        self.model.challenges
    }
    
    var selectedChallenge: StoryChallenge? {
        get {
            if let challengeIndex = model.indexOfSelectedChallenge {
                return model.challenges[challengeIndex]
            }
            return nil
        }
    }
    
    var selectedStory: Story? {
        get {
            if let challengeIndex = model.indexOfSelectedChallenge,
               let storyIndex = model.indexOfSelectedStory {
                return model.challenges[challengeIndex].stories[storyIndex]
            }
            return nil
        }
    }
    
    private var videoURL: URL?
    
    func chooseChallenge(_ challenge: StoryChallenge) {
        self.model.ChooseChallenge(challenge: challenge)
    }
    
    func chooseStory(story: Story) {
        self.model.ChooseStory(story: story)
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
        print("当前选择故事的self.selectedStory?.isFinished = \(self.selectedStory?.isFinished ?? false)")
    }
}

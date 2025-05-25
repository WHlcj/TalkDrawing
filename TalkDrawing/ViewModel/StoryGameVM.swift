import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    static let shared = StoryGameVM()
    
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
    
    func chooseChallenge(_ challenge: StoryChallenge) {
        self.model.ChooseChallenge(challenge: challenge)
    }
    
    func chooseStory(story: Story) {
        self.model.ChooseStory(story: story)
        initVideoPlayer()
    }

    func initVideoPlayer() {
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
            VideoManager.shared.initPlayer(url: challenges[challengeIndex].stories[storyIndex].videoUrl)
        }
    }
    
    func playVideo() {
        VideoManager.shared.play()
    }
    
    func stopVideo() {
        VideoManager.shared.pause()
    }
    
    func finishedGame() {
        self.model.FinishStory()
    }
}

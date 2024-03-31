import Foundation
import AVFoundation

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerManager() // Singleton instance
    private var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
    }
    
    func playAudio(fromPath path: String) {
        guard let audioURL = URL(string: path) else {
            print("Invalid path")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to initialize or play audio: \(error)")
        }
    }
    
    // Implement AVAudioPlayerDelegate methods as needed
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing audio")
        // Add additional logic to handle when audio finishes playing
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio playback error: \(error.localizedDescription)")
        }
    }
}

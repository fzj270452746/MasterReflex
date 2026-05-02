import Foundation
import AVFoundation
import UIKit

// Audio and haptic feedback manager using low-frequency vocabulary
class SensoryOrchestrator {

    static let shared = SensoryOrchestrator()

    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    private init() {
        hapticGenerator.prepare()
    }

    // MARK: - Audio

    func playAudioEffect(named soundName: String) {
        guard PersistenceOrchestrator.shared.isAudioEnabled() else { return }

        if let player = audioPlayers[soundName] {
            player.currentTime = 0
            player.play()
        } else {
            // Create simple beep sounds programmatically if no audio files exist
            generateSimpleBeep(for: soundName)
        }
    }

    private func generateSimpleBeep(for soundName: String) {
        // Generate simple system sounds for different events
        let systemSoundID: SystemSoundID
        switch soundName {
        case "colorChange":
            systemSoundID = 1104 // SMS received tone
        case "success":
            systemSoundID = 1054 // Message sent
        case "failure":
            systemSoundID = 1053 // Shake
        case "combo":
            systemSoundID = 1057 // Anticipate
        default:
            systemSoundID = 1104
        }
        AudioServicesPlaySystemSound(systemSoundID)
    }

    func playColorTransitionSound() {
        playAudioEffect(named: "colorChange")
    }

    func playTriumphSound() {
        playAudioEffect(named: "success")
    }

    func playFailureSound() {
        playAudioEffect(named: "failure")
    }

    func playConsecutiveStreakSound() {
        playAudioEffect(named: "combo")
    }

    // MARK: - Haptic

    func triggerHapticPulse(intensity: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard PersistenceOrchestrator.shared.isHapticEnabled() else { return }

        let generator = UIImpactFeedbackGenerator(style: intensity)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerLightHaptic() {
        triggerHapticPulse(intensity: .light)
    }

    func triggerMediumHaptic() {
        triggerHapticPulse(intensity: .medium)
    }

    func triggerHeavyHaptic() {
        triggerHapticPulse(intensity: .heavy)
    }

    func triggerSuccessHaptic() {
        guard PersistenceOrchestrator.shared.isHapticEnabled() else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func triggerErrorHaptic() {
        guard PersistenceOrchestrator.shared.isHapticEnabled() else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

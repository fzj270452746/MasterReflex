import Foundation

// Data persistence manager using low-frequency vocabulary
class PersistenceOrchestrator {

    static let shared = PersistenceOrchestrator()

    private let userDefaults = UserDefaults.standard

    // Keys using low-frequency vocabulary
    private enum ArchiveKey: String {
        case swiftestReactionDuration = "swiftestReactionDuration"
        case aggregateReactionDuration = "aggregateReactionDuration"
        case totalAttemptQuantity = "totalAttemptQuantity"
        case triumphantAttemptQuantity = "triumphantAttemptQuantity"
        case supremeScore = "supremeScore"
        case leaderboardScores = "leaderboardScores"
        case longestConsecutiveStreak = "longestConsecutiveStreak"
        case unlockedChromaticThemes = "unlockedChromaticThemes"
        case currentChromaticTheme = "currentChromaticTheme"
        case accumulatedEnergyPoints = "accumulatedEnergyPoints"
        case accomplishedAchievements = "accomplishedAchievements"
        case audioEnabled = "audioEnabled"
        case hapticEnabled = "hapticEnabled"
    }

    private init() {}

    // MARK: - Statistics

    func recordReactionDuration(_ milliseconds: Double, wasTriumphant: Bool) {
        let totalAttempts = retrieveTotalAttempts()
        let currentAverage = retrieveAverageReactionDuration()

        // Update fastest reaction
        let currentFastest = retrieveSwiftestReaction()
        if wasTriumphant && (currentFastest == 0 || milliseconds < currentFastest) {
            userDefaults.set(milliseconds, forKey: ArchiveKey.swiftestReactionDuration.rawValue)
        }

        // Update average reaction
        let newAverage = (currentAverage * Double(totalAttempts) + milliseconds) / Double(totalAttempts + 1)
        userDefaults.set(newAverage, forKey: ArchiveKey.aggregateReactionDuration.rawValue)

        // Update attempt counts
        userDefaults.set(totalAttempts + 1, forKey: ArchiveKey.totalAttemptQuantity.rawValue)

        if wasTriumphant {
            let successfulAttempts = retrieveTriumphantAttempts()
            userDefaults.set(successfulAttempts + 1, forKey: ArchiveKey.triumphantAttemptQuantity.rawValue)
        }
    }

    func retrieveSwiftestReaction() -> Double {
        return userDefaults.double(forKey: ArchiveKey.swiftestReactionDuration.rawValue)
    }

    func retrieveAverageReactionDuration() -> Double {
        return userDefaults.double(forKey: ArchiveKey.aggregateReactionDuration.rawValue)
    }

    func retrieveTotalAttempts() -> Int {
        return userDefaults.integer(forKey: ArchiveKey.totalAttemptQuantity.rawValue)
    }

    func retrieveTriumphantAttempts() -> Int {
        return userDefaults.integer(forKey: ArchiveKey.triumphantAttemptQuantity.rawValue)
    }

    func calculateTriumphRate() -> Double {
        let total = retrieveTotalAttempts()
        guard total > 0 else { return 0 }
        return Double(retrieveTriumphantAttempts()) / Double(total) * 100
    }

    // MARK: - Score

    func recordSupremeScore(_ score: Int) {
        let currentSupreme = retrieveSupremeScore()
        if score > currentSupreme {
            userDefaults.set(score, forKey: ArchiveKey.supremeScore.rawValue)
        }
    }

    func retrieveSupremeScore() -> Int {
        return userDefaults.integer(forKey: ArchiveKey.supremeScore.rawValue)
    }

    func recordLeaderboardScore(_ score: Int) {
        guard score > 0 else { return }

        var scores = retrieveLeaderboardScores()
        scores.append(score)
        scores.sort(by: >)
        scores = Array(scores.prefix(10))

        userDefaults.set(scores, forKey: ArchiveKey.leaderboardScores.rawValue)
    }

    func retrieveLeaderboardScores() -> [Int] {
        return userDefaults.array(forKey: ArchiveKey.leaderboardScores.rawValue) as? [Int] ?? []
    }

    // MARK: - Combo

    func recordConsecutiveStreak(_ streak: Int) {
        let currentLongest = retrieveLongestStreak()
        if streak > currentLongest {
            userDefaults.set(streak, forKey: ArchiveKey.longestConsecutiveStreak.rawValue)
        }
    }

    func retrieveLongestStreak() -> Int {
        return userDefaults.integer(forKey: ArchiveKey.longestConsecutiveStreak.rawValue)
    }

    // MARK: - Themes

    func unlockChromaticTheme(_ theme: VelocityConfiguration.ChromaticTheme) {
        var unlockedThemes = retrieveUnlockedThemes()
        if !unlockedThemes.contains(theme.rawValue) {
            unlockedThemes.append(theme.rawValue)
            userDefaults.set(unlockedThemes, forKey: ArchiveKey.unlockedChromaticThemes.rawValue)
        }
    }

    func retrieveUnlockedThemes() -> [String] {
        return userDefaults.stringArray(forKey: ArchiveKey.unlockedChromaticThemes.rawValue) ?? [VelocityConfiguration.ChromaticTheme.primordial.rawValue]
    }

    func storeCurrentTheme(_ theme: VelocityConfiguration.ChromaticTheme) {
        userDefaults.set(theme.rawValue, forKey: ArchiveKey.currentChromaticTheme.rawValue)
    }

    func retrieveCurrentTheme() -> VelocityConfiguration.ChromaticTheme {
        if let themeString = userDefaults.string(forKey: ArchiveKey.currentChromaticTheme.rawValue),
           let theme = VelocityConfiguration.ChromaticTheme(rawValue: themeString) {
            return theme
        }
        return .primordial
    }

    // MARK: - Energy Points

    func accumulateEnergyPoints(_ points: Int) {
        let current = retrieveEnergyPoints()
        userDefaults.set(current + points, forKey: ArchiveKey.accumulatedEnergyPoints.rawValue)
    }

    func expendEnergyPoints(_ points: Int) -> Bool {
        let current = retrieveEnergyPoints()
        guard current >= points else { return false }
        userDefaults.set(current - points, forKey: ArchiveKey.accumulatedEnergyPoints.rawValue)
        return true
    }

    func retrieveEnergyPoints() -> Int {
        return userDefaults.integer(forKey: ArchiveKey.accumulatedEnergyPoints.rawValue)
    }

    // MARK: - Achievements

    func accomplishAchievement(_ achievementId: String) {
        var accomplished = retrieveAccomplishedAchievements()
        if !accomplished.contains(achievementId) {
            accomplished.append(achievementId)
            userDefaults.set(accomplished, forKey: ArchiveKey.accomplishedAchievements.rawValue)
        }
    }

    func retrieveAccomplishedAchievements() -> [String] {
        return userDefaults.stringArray(forKey: ArchiveKey.accomplishedAchievements.rawValue) ?? []
    }

    // MARK: - Settings

    func toggleAudio(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: ArchiveKey.audioEnabled.rawValue)
    }

    func isAudioEnabled() -> Bool {
        return userDefaults.object(forKey: ArchiveKey.audioEnabled.rawValue) == nil ? true : userDefaults.bool(forKey: ArchiveKey.audioEnabled.rawValue)
    }

    func toggleHaptic(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: ArchiveKey.hapticEnabled.rawValue)
    }

    func isHapticEnabled() -> Bool {
        return userDefaults.object(forKey: ArchiveKey.hapticEnabled.rawValue) == nil ? true : userDefaults.bool(forKey: ArchiveKey.hapticEnabled.rawValue)
    }

    // MARK: - Reset

    func resetAllData() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }
}

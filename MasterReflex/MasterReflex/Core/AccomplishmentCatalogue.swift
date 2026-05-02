import Foundation

// Achievement system using low-frequency vocabulary
struct AccomplishmentCatalogue {

    enum AccomplishmentIdentifier: String, CaseIterable {
        case velocityPhantom = "velocity_phantom"
        case consistentPerformer = "consistent_performer"
        case decupleStreak = "decuple_streak"
        case concentrationMaestro = "concentration_maestro"
        case centuryMilestone = "century_milestone"
        case marathonEndurance = "marathon_endurance"
        case flawlessExecution = "flawless_execution"
        case supremacyAchieved = "supremacy_achieved"

        var title: String {
            switch self {
            case .velocityPhantom: return "Lightning Phantom"
            case .consistentPerformer: return "Steady Hand"
            case .decupleStreak: return "Ten Strike"
            case .concentrationMaestro: return "Focus Master"
            case .centuryMilestone: return "Century Club"
            case .marathonEndurance: return "Marathon Runner"
            case .flawlessExecution: return "Perfectionist"
            case .supremacyAchieved: return "Supreme Champion"
            }
        }

        var description: String {
            switch self {
            case .velocityPhantom: return "React under 150ms"
            case .consistentPerformer: return "Average under 250ms"
            case .decupleStreak: return "10 consecutive successes"
            case .concentrationMaestro: return "20 consecutive successes"
            case .centuryMilestone: return "Complete 100 attempts"
            case .marathonEndurance: return "Complete 500 attempts"
            case .flawlessExecution: return "Perfect Classic Mode"
            case .supremacyAchieved: return "Score over 5000"
            }
        }

        var energyReward: Int {
            switch self {
            case .velocityPhantom: return 50
            case .consistentPerformer: return 30
            case .decupleStreak: return 40
            case .concentrationMaestro: return 80
            case .centuryMilestone: return 100
            case .marathonEndurance: return 200
            case .flawlessExecution: return 150
            case .supremacyAchieved: return 250
            }
        }
    }

    static func evaluateAccomplishments(reactionTime: Double, streak: Int, score: Int) -> [AccomplishmentIdentifier] {
        var newAccomplishments: [AccomplishmentIdentifier] = []
        let accomplished = PersistenceOrchestrator.shared.retrieveAccomplishedAchievements()

        // Check velocity phantom
        if reactionTime < VelocityConfiguration.transcendentThreshold &&
           !accomplished.contains(AccomplishmentIdentifier.velocityPhantom.rawValue) {
            newAccomplishments.append(.velocityPhantom)
        }

        // Check consistent performer
        let avgReaction = PersistenceOrchestrator.shared.retrieveAverageReactionDuration()
        if avgReaction > 0 && avgReaction < VelocityConfiguration.exemplaryThreshold &&
           !accomplished.contains(AccomplishmentIdentifier.consistentPerformer.rawValue) {
            newAccomplishments.append(.consistentPerformer)
        }

        // Check decuple streak
        if streak >= 10 && !accomplished.contains(AccomplishmentIdentifier.decupleStreak.rawValue) {
            newAccomplishments.append(.decupleStreak)
        }

        // Check concentration maestro
        if streak >= 20 && !accomplished.contains(AccomplishmentIdentifier.concentrationMaestro.rawValue) {
            newAccomplishments.append(.concentrationMaestro)
        }

        // Check century milestone
        let totalAttempts = PersistenceOrchestrator.shared.retrieveTotalAttempts()
        if totalAttempts >= 100 && !accomplished.contains(AccomplishmentIdentifier.centuryMilestone.rawValue) {
            newAccomplishments.append(.centuryMilestone)
        }

        // Check marathon endurance
        if totalAttempts >= 500 && !accomplished.contains(AccomplishmentIdentifier.marathonEndurance.rawValue) {
            newAccomplishments.append(.marathonEndurance)
        }

        // Check supremacy achieved
        if score > 5000 && !accomplished.contains(AccomplishmentIdentifier.supremacyAchieved.rawValue) {
            newAccomplishments.append(.supremacyAchieved)
        }

        // Record new accomplishments
        for accomplishment in newAccomplishments {
            PersistenceOrchestrator.shared.accomplishAchievement(accomplishment.rawValue)
            PersistenceOrchestrator.shared.accumulateEnergyPoints(accomplishment.energyReward)
        }

        return newAccomplishments
    }
}

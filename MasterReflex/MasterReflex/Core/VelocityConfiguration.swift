import Foundation
import UIKit

// Configuration manager using low-frequency vocabulary
struct VelocityConfiguration {

    // Reaction time thresholds (in milliseconds)
    static let transcendentThreshold: Double = 150
    static let swiftThreshold: Double = 200
    static let exemplaryThreshold: Double = 250
    static let adequateThreshold: Double = 300
    static let mediocreThreshold: Double = 400

    // Score calculation
    static let maximumBaseScore: Int = 500

    // Classic mode settings
    static let classicRoundQuantity: Int = 10

    // Color change delay range (seconds)
    static let minimumDelayInterval: Double = 1.0
    static let maximumDelayInterval: Double = 5.0

    // Grid mode settings
    static let initialGridDimension: Int = 3
    static let gridResponseWindow: Double = 1.0

    // Mind trap settings
    static let ephemeralColorDuration: Double = 0.05
    static let deceptionActivationRound: Int = 6

    // Color themes
    enum ChromaticTheme: String, CaseIterable {
        case primordial = "Classic"
        case technological = "Tech"
        case luminescent = "Neon"
        case monochromatic = "Monochrome"

        var initialHue: UIColor {
            switch self {
            case .primordial: return UIColor(red: 0.95, green: 0.26, blue: 0.21, alpha: 1.0)
            case .technological: return UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
            case .luminescent: return UIColor(red: 0.58, green: 0.24, blue: 0.82, alpha: 1.0)
            case .monochromatic: return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
            }
        }

        var targetHue: UIColor {
            switch self {
            case .primordial: return UIColor(red: 0.18, green: 0.8, blue: 0.44, alpha: 1.0)
            case .technological: return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            case .luminescent: return UIColor(red: 0.98, green: 0.4, blue: 0.76, alpha: 1.0)
            case .monochromatic: return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            }
        }
    }

    // Evaluation ratings
    enum VelocityRating: String {
        case transcendent = "Godlike"
        case phenomenal = "Lightning"
        case exemplary = "Excellent"
        case adequate = "Good"
        case mediocre = "Average"
        case sluggish = "Slow"

        static func evaluate(milliseconds: Double) -> VelocityRating {
            if milliseconds < transcendentThreshold {
                return .transcendent
            } else if milliseconds < swiftThreshold {
                return .phenomenal
            } else if milliseconds < exemplaryThreshold {
                return .exemplary
            } else if milliseconds < adequateThreshold {
                return .adequate
            } else if milliseconds < mediocreThreshold {
                return .mediocre
            } else {
                return .sluggish
            }
        }
    }
}

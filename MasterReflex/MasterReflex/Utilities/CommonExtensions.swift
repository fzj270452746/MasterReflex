import SpriteKit
import UIKit

// Common extensions for all scenes
extension SKScene {

    // Calculate font size based on screen height for better adaptation
    func calculateFontSize(base: CGFloat) -> CGFloat {
        let screenHeight = size.height
        let referenceHeight: CGFloat = 667.0 // iPhone 8 reference
        let scaleFactor = screenHeight / referenceHeight
        return base * scaleFactor
    }

    func createSymbolNode(symbolName: String, pointSize: CGFloat, color: UIColor) -> SKSpriteNode {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        let image = UIImage(systemName: symbolName, withConfiguration: configuration) ?? UIImage()
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.color = color
        node.colorBlendFactor = 1.0
        node.size = CGSize(width: pointSize, height: pointSize)
        return node
    }
}

// Extension for SKNode to add common utilities
extension SKNode {

    // Shake animation for error feedback
    func performShakeAnimation() {
        let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shakeRight = SKAction.moveBy(x: 20, y: 0, duration: 0.05)
        let shakeBack = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shake = SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight, shakeBack])
        run(shake)
    }

    // Pulse animation for emphasis
    func performPulseAnimation(scale: CGFloat = 1.2, duration: TimeInterval = 0.2) {
        let scaleUp = SKAction.scale(to: scale, duration: duration)
        let scaleDown = SKAction.scale(to: 1.0, duration: duration)
        run(SKAction.sequence([scaleUp, scaleDown]))
    }

    // Fade in animation
    func performFadeInAnimation(duration: TimeInterval = 0.3) {
        alpha = 0
        run(SKAction.fadeIn(withDuration: duration))
    }

    // Fade out animation
    func performFadeOutAnimation(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        run(SKAction.fadeOut(withDuration: duration)) {
            completion?()
        }
    }
}

// Extension for CGFloat to add utility methods
extension CGFloat {

    // Clamp value between min and max
    func clamped(min: CGFloat, max: CGFloat) -> CGFloat {
        return Swift.min(Swift.max(self, min), max)
    }

    // Linear interpolation
    func lerp(to target: CGFloat, factor: CGFloat) -> CGFloat {
        return self + (target - self) * factor
    }
}

// Extension for Double to add utility methods
extension Double {

    // Format milliseconds to string
    func formatAsMilliseconds() -> String {
        return String(format: "%.0f ms", self)
    }

    // Format as percentage
    func formatAsPercentage() -> String {
        return String(format: "%.1f%%", self)
    }
}

// Extension for Int to add utility methods
extension Int {

    // Format with thousands separator
    func formatWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

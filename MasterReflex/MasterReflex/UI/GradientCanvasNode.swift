import SpriteKit

// Gradient background node for scenes
class GradientCanvasNode: SKNode {

    private let topColorSprite: SKSpriteNode
    private let bottomColorSprite: SKSpriteNode

    init(size: CGSize, topColor: UIColor, bottomColor: UIColor) {
        topColorSprite = SKSpriteNode(color: topColor, size: size)
        bottomColorSprite = SKSpriteNode(color: bottomColor, size: size)

        super.init()

        // Position sprites
        topColorSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        topColorSprite.zPosition = -100
        bottomColorSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bottomColorSprite.zPosition = -99
        bottomColorSprite.alpha = 0.5

        addChild(topColorSprite)
        addChild(bottomColorSprite)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func transitionToColors(topColor: UIColor, bottomColor: UIColor, duration: TimeInterval = 0.3) {
        let topColorAction = SKAction.colorize(with: topColor, colorBlendFactor: 1.0, duration: duration)
        let bottomColorAction = SKAction.colorize(with: bottomColor, colorBlendFactor: 1.0, duration: duration)

        topColorSprite.run(topColorAction)
        bottomColorSprite.run(bottomColorAction)
    }

    func animateColorPulse(color: UIColor, duration: TimeInterval = 0.15) {
        let originalColor = topColorSprite.color
        let pulseToColor = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: duration)
        let pulseBack = SKAction.colorize(with: originalColor, colorBlendFactor: 1.0, duration: duration)
        let sequence = SKAction.sequence([pulseToColor, pulseBack])

        topColorSprite.run(sequence)
    }
}

// Extension for creating gradient colors
extension UIColor {
    static func createGradientColor(from color1: UIColor, to color2: UIColor, percentage: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = r1 + (r2 - r1) * percentage
        let g = g1 + (g2 - g1) * percentage
        let b = b1 + (b2 - b1) * percentage
        let a = a1 + (a2 - a1) * percentage

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    func lighter(by percentage: CGFloat = 0.3) -> UIColor {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        return self.adjust(by: -abs(percentage))
    }

    func adjust(by percentage: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return UIColor(
            red: min(r + percentage, 1.0),
            green: min(g + percentage, 1.0),
            blue: min(b + percentage, 1.0),
            alpha: a
        )
    }
}

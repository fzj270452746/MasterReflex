import SpriteKit

// Custom button node with gradient and animations
class LuminousButtonNode: SKNode {

    private let backgroundShape: SKShapeNode
    private let labelNode: SKLabelNode
    private var originalScale: CGFloat = 1.0
    private var actionHandler: (() -> Void)?

    init(text: String, size: CGSize, gradientColors: [UIColor]) {
        backgroundShape = SKShapeNode(rectOf: size, cornerRadius: size.height * 0.25)
        labelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")

        super.init()

        // Setup background with gradient effect
        backgroundShape.fillColor = gradientColors.first ?? .white
        backgroundShape.strokeColor = .clear
        backgroundShape.lineWidth = 0

        addChild(backgroundShape)

        // Setup label
        labelNode.text = text
        labelNode.fontSize = size.height * 0.4
        labelNode.fontColor = .white
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        addChild(labelNode)

        isUserInteractionEnabled = true

        // Add subtle pulse animation
        let pulseUp = SKAction.scale(to: 1.05, duration: 0.8)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.8)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        backgroundShape.run(SKAction.repeatForever(pulse))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setActionHandler(_ handler: @escaping () -> Void) {
        self.actionHandler = handler
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        run(scaleDown)
        SensoryOrchestrator.shared.triggerLightHaptic()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        run(scaleUp)

        if let touch = touches.first {
            let location = touch.location(in: self)
            if backgroundShape.contains(location) {
                actionHandler?()
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        run(scaleUp)
    }

    func updateText(_ newText: String) {
        labelNode.text = newText
    }

    func applyGradientColors(_ colors: [UIColor]) {
        if let firstColor = colors.first {
            backgroundShape.fillColor = firstColor
        }
    }
}

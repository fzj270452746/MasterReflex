import SpriteKit

// Custom modal dialog with gradient background
class EtherealDialogNode: SKNode {

    private let overlayNode: SKSpriteNode
    private let containerShape: SKShapeNode
    private let titleLabel: SKLabelNode
    private let messageLabel: SKLabelNode
    private var buttons: [LuminousButtonNode] = []
    private var dismissHandler: (() -> Void)?

    init(title: String, message: String, size: CGSize) {
        // Semi-transparent overlay
        overlayNode = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: size)
        overlayNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlayNode.zPosition = 100

        // Dialog container
        let dialogWidth = size.width * 0.85
        let dialogHeight = size.height * 0.5
        containerShape = SKShapeNode(rectOf: CGSize(width: dialogWidth, height: dialogHeight), cornerRadius: 20)
        containerShape.fillColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        containerShape.strokeColor = UIColor(white: 1.0, alpha: 0.3)
        containerShape.lineWidth = 2
        containerShape.position = CGPoint(x: size.width / 2, y: size.height / 2)
        containerShape.zPosition = 101

        // Title label
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = title
        titleLabel.fontSize = 28
        titleLabel.fontColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        titleLabel.position = CGPoint(x: 0, y: dialogHeight * 0.3)
        titleLabel.zPosition = 102

        // Message label
        messageLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        messageLabel.text = message
        messageLabel.fontSize = 18
        messageLabel.fontColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
        messageLabel.numberOfLines = 0
        messageLabel.preferredMaxLayoutWidth = dialogWidth * 0.8
        messageLabel.position = CGPoint(x: 0, y: dialogHeight * 0.05)
        messageLabel.zPosition = 102

        super.init()

        addChild(overlayNode)
        addChild(containerShape)
        containerShape.addChild(titleLabel)
        containerShape.addChild(messageLabel)

        isUserInteractionEnabled = true

        // Entrance animation
        containerShape.setScale(0.5)
        containerShape.alpha = 0
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        scaleUp.timingMode = .easeOut
        containerShape.run(SKAction.group([scaleUp, fadeIn]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addButton(text: String, colors: [UIColor], action: @escaping () -> Void) {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        let button = LuminousButtonNode(text: text, size: CGSize(width: buttonWidth, height: buttonHeight), gradientColors: colors)

        let yOffset = -containerShape.frame.height * 0.25 - CGFloat(buttons.count) * (buttonHeight + 15)
        button.position = CGPoint(x: 0, y: yOffset)
        button.zPosition = 102

        button.setActionHandler { [weak self] in
            action()
            self?.dismiss()
        }

        containerShape.addChild(button)
        buttons.append(button)
    }

    func setDismissHandler(_ handler: @escaping () -> Void) {
        self.dismissHandler = handler
    }

    func dismiss() {
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        scaleDown.timingMode = .easeIn

        containerShape.run(SKAction.group([scaleDown, fadeOut])) { [weak self] in
            self?.dismissHandler?()
            self?.removeFromParent()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Prevent touches from passing through
    }
}

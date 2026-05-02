import SpriteKit

// Settings scene
class ConfigurationPanoramaVista: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var titleLabel: SKLabelNode!
    private var settingsContainer: SKNode!

    override func didMove(to view: SKView) {
        let theme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        gradientCanvas = GradientCanvasNode(
            size: size,
            topColor: theme.initialHue.darker(by: 0.2),
            bottomColor: theme.targetHue.darker(by: 0.3)
        )
        addChild(gradientCanvas)

        setupTitle()
        setupSettings()
    }

    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "Settings"
        titleLabel.fontSize = calculateFontSize(base: 36)
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 130)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        let backButton = LuminousButtonNode(
            text: "← Back",
            size: CGSize(width: 100, height: 40),
            gradientColors: [UIColor(white: 0.3, alpha: 0.8)]
        )
        backButton.position = CGPoint(x: 70, y: size.height * 0.92)
        backButton.setActionHandler { [weak self] in
            self?.returnToMenu()
        }
        addChild(backButton)
    }

    private func setupSettings() {
        settingsContainer = SKNode()
        settingsContainer.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(settingsContainer)

        var yOffset: CGFloat = 0

        // Audio toggle
        let audioToggle = createToggleSetting(
            title: "Sound Effects",
            isEnabled: PersistenceOrchestrator.shared.isAudioEnabled(),
            toggleAction: { [weak self] isEnabled in
                PersistenceOrchestrator.shared.toggleAudio(isEnabled)
                if isEnabled {
                    SensoryOrchestrator.shared.playTriumphSound()
                }
            }
        )
        audioToggle.position = CGPoint(x: 0, y: yOffset)
        settingsContainer.addChild(audioToggle)
        yOffset -= 100

        // Haptic toggle
        let hapticToggle = createToggleSetting(
            title: "Haptic Feedback",
            isEnabled: PersistenceOrchestrator.shared.isHapticEnabled(),
            toggleAction: { [weak self] isEnabled in
                PersistenceOrchestrator.shared.toggleHaptic(isEnabled)
                if isEnabled {
                    SensoryOrchestrator.shared.triggerMediumHaptic()
                }
            }
        )
        hapticToggle.position = CGPoint(x: 0, y: yOffset)
        settingsContainer.addChild(hapticToggle)
        yOffset -= 120

        // Reset data button
        let resetButton = LuminousButtonNode(
            text: "Reset All Data",
            size: CGSize(width: size.width * 0.7, height: 55),
            gradientColors: [UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)]
        )
        resetButton.position = CGPoint(x: 0, y: yOffset)
        resetButton.setActionHandler { [weak self] in
            self?.showResetConfirmation()
        }
        settingsContainer.addChild(resetButton)
        yOffset -= 80

        // About section
        let aboutLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        aboutLabel.text = "Master Reflex v1.0"
        aboutLabel.fontSize = calculateFontSize(base: 16)
        aboutLabel.fontColor = UIColor(white: 0.7, alpha: 1.0)
        aboutLabel.position = CGPoint(x: 0, y: yOffset)
        settingsContainer.addChild(aboutLabel)
        yOffset -= 30

        let copyrightLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        copyrightLabel.text = "Test Your Reaction Speed"
        copyrightLabel.fontSize = calculateFontSize(base: 14)
        copyrightLabel.fontColor = UIColor(white: 0.6, alpha: 1.0)
        copyrightLabel.position = CGPoint(x: 0, y: yOffset)
        settingsContainer.addChild(copyrightLabel)
    }

    private func createToggleSetting(title: String, isEnabled: Bool, toggleAction: @escaping (Bool) -> Void) -> SKNode {
        let container = SKNode()

        let cardWidth = size.width * 0.85
        let cardHeight: CGFloat = 80

        let background = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 12)
        background.fillColor = UIColor(white: 0.2, alpha: 0.8)
        background.strokeColor = UIColor(white: 0.4, alpha: 0.5)
        background.lineWidth = 2
        container.addChild(background)

        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = title
        titleLabel.fontSize = calculateFontSize(base: 20)
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.position = CGPoint(x: -cardWidth * 0.4, y: -8)
        container.addChild(titleLabel)

        // Toggle switch
        let toggleWidth: CGFloat = 60
        let toggleHeight: CGFloat = 32
        let toggleBackground = SKShapeNode(rectOf: CGSize(width: toggleWidth, height: toggleHeight), cornerRadius: toggleHeight / 2)
        toggleBackground.fillColor = isEnabled ? UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
        toggleBackground.strokeColor = .clear
        toggleBackground.position = CGPoint(x: cardWidth * 0.32, y: 0)
        toggleBackground.name = "toggleBackground"
        container.addChild(toggleBackground)

        let toggleKnob = SKShapeNode(circleOfRadius: toggleHeight * 0.4)
        toggleKnob.fillColor = .white
        toggleKnob.strokeColor = .clear
        let knobX = isEnabled ? toggleWidth * 0.3 : -toggleWidth * 0.3
        toggleKnob.position = CGPoint(x: knobX, y: 0)
        toggleKnob.name = "toggleKnob"
        toggleBackground.addChild(toggleKnob)

        // Store state
        container.userData = NSMutableDictionary()
        container.userData?["isEnabled"] = isEnabled
        container.userData?["toggleAction"] = toggleAction

        return container
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: settingsContainer)

        for child in settingsContainer.children {
            if child.contains(location), let userData = child.userData {
                if let isEnabled = userData["isEnabled"] as? Bool,
                   let toggleAction = userData["toggleAction"] as? (Bool) -> Void {

                    let newState = !isEnabled
                    userData["isEnabled"] = newState
                    toggleAction(newState)

                    // Update toggle visual
                    if let toggleBg = child.childNode(withName: "toggleBackground") as? SKShapeNode,
                       let toggleKnob = toggleBg.childNode(withName: "toggleKnob") {

                        toggleBg.fillColor = newState ? UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)

                        let knobX = newState ? 18.0 : -18.0
                        let moveAction = SKAction.moveTo(x: knobX, duration: 0.2)
                        moveAction.timingMode = .easeInEaseOut
                        toggleKnob.run(moveAction)
                    }
                }
            }
        }
    }

    private func showResetConfirmation() {
        let dialog = EtherealDialogNode(
            title: "Reset All Data?",
            message: "This will delete all your progress, statistics, and unlocked items. This action cannot be undone.",
            size: size
        )

        dialog.addButton(
            text: "Cancel",
            colors: [UIColor(white: 0.5, alpha: 1.0)],
            action: {}
        )

        dialog.addButton(
            text: "Reset Everything",
            colors: [UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)],
            action: { [weak self] in
                self?.resetAllData()
            }
        )

        addChild(dialog)
    }

    private func resetAllData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        let confirmDialog = EtherealDialogNode(
            title: "Data Reset",
            message: "All data has been reset successfully.",
            size: size
        )

        confirmDialog.addButton(
            text: "OK",
            colors: [UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0)],
            action: { [weak self] in
                self?.returnToMenu()
            }
        )

        addChild(confirmDialog)
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

}

import SpriteKit

// Main menu scene using low-frequency vocabulary
class PrimordialMenuVista: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var titleLabel: SKLabelNode!
    private var subtitleLabel: SKLabelNode!
    private var buttonContainer: SKNode!

    override func didMove(to view: SKView) {
        setupGradientBackground()
        setupTitle()
        setupButtons()
        setupStatisticsDisplay()
    }

    private func setupGradientBackground() {
        let theme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        gradientCanvas = GradientCanvasNode(
            size: size,
            topColor: theme.initialHue,
            bottomColor: theme.targetHue
        )
        addChild(gradientCanvas)
    }

    private func setupTitle() {
        // Main title - Line 1
        let titleLine1 = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLine1.text = "Master"
        titleLine1.fontSize = calculateFontSize(base: 48)
        titleLine1.fontColor = .white
        titleLine1.position = CGPoint(x: size.width / 2, y: size.height * 0.78)
        titleLine1.zPosition = 10
        addChild(titleLine1)

        // Glow effect for line 1
        let glowNode1 = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        glowNode1.text = "Master"
        glowNode1.fontSize = calculateFontSize(base: 48)
        glowNode1.fontColor = .white
        glowNode1.alpha = 0.3
        glowNode1.zPosition = 9
        glowNode1.setScale(1.05)
        titleLine1.addChild(glowNode1)

        // Main title - Line 2
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "Reflex"
        titleLabel.fontSize = calculateFontSize(base: 48)
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.72)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        // Glow effect for line 2
        let glowNode2 = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        glowNode2.text = "Reflex"
        glowNode2.fontSize = calculateFontSize(base: 48)
        glowNode2.fontColor = .white
        glowNode2.alpha = 0.3
        glowNode2.zPosition = 9
        glowNode2.setScale(1.05)
        titleLabel.addChild(glowNode2)

        // Subtitle
        subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        subtitleLabel.text = "Test Your Reaction Speed"
        subtitleLabel.fontSize = calculateFontSize(base: 16)
        subtitleLabel.fontColor = UIColor(white: 1.0, alpha: 0.8)
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)

        // Animate both title lines
        let pulseUp = SKAction.scale(to: 1.05, duration: 1.5)
        let pulseDown = SKAction.scale(to: 1.0, duration: 1.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        titleLine1.run(SKAction.repeatForever(pulse))
        titleLabel.run(SKAction.repeatForever(pulse))
    }

    private func setupButtons() {
        buttonContainer = SKNode()
        buttonContainer.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(buttonContainer)

        let buttonWidth = size.width * 0.7
        let buttonHeight = size.height * 0.065
        let spacing = size.height * 0.018

        // Classic Mode button
        let classicButton = createMenuButton(
            text: "Classic Mode",
            size: CGSize(width: buttonWidth, height: buttonHeight),
            colors: [UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0), UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1.0)]
        )
        classicButton.position = CGPoint(x: 0, y: spacing * 2 + buttonHeight)
        classicButton.setActionHandler { [weak self] in
            self?.navigateToClassicMode()
        }
        buttonContainer.addChild(classicButton)

        // Endless Mode button
        let endlessButton = createMenuButton(
            text: "Endless Mode",
            size: CGSize(width: buttonWidth, height: buttonHeight),
            colors: [UIColor(red: 0.9, green: 0.4, blue: 0.3, alpha: 1.0), UIColor(red: 0.7, green: 0.3, blue: 0.2, alpha: 1.0)]
        )
        endlessButton.position = CGPoint(x: 0, y: spacing)
        endlessButton.setActionHandler { [weak self] in
            self?.navigateToEndlessMode()
        }
        buttonContainer.addChild(endlessButton)

        // Mind Trap Mode button
        let mindTrapButton = createMenuButton(
            text: "Mind Trap Mode",
            size: CGSize(width: buttonWidth, height: buttonHeight),
            colors: [UIColor(red: 0.7, green: 0.3, blue: 0.8, alpha: 1.0), UIColor(red: 0.5, green: 0.2, blue: 0.6, alpha: 1.0)]
        )
        mindTrapButton.position = CGPoint(x: 0, y: -spacing - buttonHeight)
        mindTrapButton.setActionHandler { [weak self] in
            self?.navigateToMindTrapMode()
        }
        buttonContainer.addChild(mindTrapButton)

        // Grid Reflex Mode button
        let gridButton = createMenuButton(
            text: "Grid Reflex Mode",
            size: CGSize(width: buttonWidth, height: buttonHeight),
            colors: [UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0), UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0)]
        )
        gridButton.position = CGPoint(x: 0, y: -spacing * 2 - buttonHeight * 2)
        gridButton.setActionHandler { [weak self] in
            self?.navigateToGridMode()
        }
        buttonContainer.addChild(gridButton)

        // Bottom buttons
        let bottomButtonWidth = size.width * 0.42
        let bottomButtonHeight = size.height * 0.06

        // Leaderboard button
        let leaderboardButton = createMenuButton(
            text: "Stats",
            size: CGSize(width: bottomButtonWidth, height: bottomButtonHeight),
            colors: [UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0), UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)]
        )
        leaderboardButton.position = CGPoint(x: -bottomButtonWidth / 2 - 10, y: -spacing * 4 - buttonHeight * 3)
        leaderboardButton.setActionHandler { [weak self] in
            self?.navigateToStatistics()
        }
        buttonContainer.addChild(leaderboardButton)

        // Settings button
        let settingsButton = createMenuButton(
            text: "Settings",
            size: CGSize(width: bottomButtonWidth, height: bottomButtonHeight),
            colors: [UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)]
        )
        settingsButton.position = CGPoint(x: bottomButtonWidth / 2 + 10, y: -spacing * 4 - buttonHeight * 3)
        settingsButton.setActionHandler { [weak self] in
            self?.navigateToSettings()
        }
        buttonContainer.addChild(settingsButton)
    }

    private func setupStatisticsDisplay() {
        let statsContainer = SKNode()
        statsContainer.position = CGPoint(x: size.width / 2, y: size.height * 0.12)
        addChild(statsContainer)

        let fastestReaction = PersistenceOrchestrator.shared.retrieveSwiftestReaction()
        let totalAttempts = PersistenceOrchestrator.shared.retrieveTotalAttempts()

        let statsText = fastestReaction > 0 ?
            "Best: \(Int(fastestReaction))ms | Attempts: \(totalAttempts)" :
            "Start playing to track your stats!"

        let statsLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        statsLabel.text = statsText
        statsLabel.fontSize = calculateFontSize(base: 14)
        statsLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        statsLabel.zPosition = 10
        statsContainer.addChild(statsLabel)
    }

    private func createMenuButton(text: String, size: CGSize, colors: [UIColor]) -> LuminousButtonNode {
        return LuminousButtonNode(text: text, size: size, gradientColors: colors)
    }


    // MARK: - Navigation

    private func navigateToClassicMode() {
        SensoryOrchestrator.shared.triggerMediumHaptic()
        let classicScene = ClassicVelocityArena(size: size)
        classicScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(classicScene, transition: transition)
    }

    private func navigateToEndlessMode() {
        SensoryOrchestrator.shared.triggerMediumHaptic()
        let endlessScene = EndlessVelocityArena(size: size)
        endlessScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(endlessScene, transition: transition)
    }

    private func navigateToMindTrapMode() {
        SensoryOrchestrator.shared.triggerMediumHaptic()
        let mindTrapScene = MindTrapVelocityArena(size: size)
        mindTrapScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(mindTrapScene, transition: transition)
    }

    private func navigateToGridMode() {
        SensoryOrchestrator.shared.triggerMediumHaptic()
        let gridScene = GridVelocityArena(size: size)
        gridScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gridScene, transition: transition)
    }

    private func navigateToStatistics() {
        SensoryOrchestrator.shared.triggerLightHaptic()
        let statsScene = StatisticalPanoramaVista(size: size)
        statsScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(statsScene, transition: transition)
    }

    private func navigateToSettings() {
        SensoryOrchestrator.shared.triggerLightHaptic()
        let settingsScene = ConfigurationPanoramaVista(size: size)
        settingsScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(settingsScene, transition: transition)
    }

    private func navigateToAccomplishments() {
        SensoryOrchestrator.shared.triggerLightHaptic()
        let accomplishmentScene = AccomplishmentGalleryVista(size: size)
        accomplishmentScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(accomplishmentScene, transition: transition)
    }
}

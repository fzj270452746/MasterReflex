import SpriteKit

// Endless mode game scene
class EndlessVelocityArena: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var currentTheme: VelocityConfiguration.ChromaticTheme!

    private var consecutiveStreak: Int = 0
    private var totalScore: Int = 0
    private var difficultyMultiplier: Double = 1.0

    private var colorTransitionTimestamp: TimeInterval = 0
    private var isAwaitingColorTransition: Bool = false
    private var hasColorTransitioned: Bool = false

    private var comboLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var instructionLabel: SKLabelNode!
    private var backButton: LuminousButtonNode!
    private var isGamePaused: Bool = false
    private var isPausedForDialog: Bool = false

    override func didMove(to view: SKView) {
        currentTheme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        setupGradientBackground()
        setupLabels()
        initiateNextRound()
    }

    private func setupGradientBackground() {
        gradientCanvas = GradientCanvasNode(
            size: size,
            topColor: currentTheme.initialHue,
            bottomColor: currentTheme.initialHue.darker(by: 0.2)
        )
        addChild(gradientCanvas)
    }

    private func setupLabels() {
        // Back button
        backButton = LuminousButtonNode(
            text: "← Back",
            size: CGSize(width: 90, height: 40),
            gradientColors: [UIColor(white: 0.3, alpha: 0.8)]
        )
        backButton.position = CGPoint(x: 60, y: size.height * 0.92)
        backButton.zPosition = 20
        backButton.setActionHandler { [weak self] in
            self?.showExitConfirmation()
        }
        addChild(backButton)

        // Combo label
        comboLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        comboLabel.fontSize = calculateFontSize(base: 28)
        comboLabel.fontColor = .white
        comboLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        comboLabel.zPosition = 10
        comboLabel.text = "Streak: \(consecutiveStreak)"
        addChild(comboLabel)

        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = calculateFontSize(base: 24)
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.15)
        scoreLabel.zPosition = 10
        scoreLabel.text = "Score: \(totalScore)"
        addChild(scoreLabel)

        // Instruction label
        instructionLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        instructionLabel.fontSize = calculateFontSize(base: 18)
        instructionLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        instructionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        instructionLabel.zPosition = 10
        instructionLabel.text = "Wait for color change..."
        addChild(instructionLabel)
    }

    private func initiateNextRound() {
        instructionLabel.text = "Wait for color change..."
        instructionLabel.fontSize = calculateFontSize(base: 18)
        instructionLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        instructionLabel.alpha = 1.0

        hasColorTransitioned = false
        isAwaitingColorTransition = true

        // Reset to initial color
        gradientCanvas.transitionToColors(
            topColor: currentTheme.initialHue,
            bottomColor: currentTheme.initialHue.darker(by: 0.2),
            duration: 0.3
        )

        // Increase difficulty over time
        difficultyMultiplier = 1.0 - (Double(consecutiveStreak) * 0.05)
        difficultyMultiplier = max(difficultyMultiplier, 0.3) // Minimum 30% of original delay

        let baseDelay = Double.random(
            in: VelocityConfiguration.minimumDelayInterval...VelocityConfiguration.maximumDelayInterval
        )
        let adjustedDelay = baseDelay * difficultyMultiplier

        let waitAction = SKAction.wait(forDuration: adjustedDelay)
        let transitionAction = SKAction.run { [weak self] in
            self?.executeColorTransition()
        }

        run(SKAction.sequence([waitAction, transitionAction]))
    }

    private func executeColorTransition() {
        guard isAwaitingColorTransition else { return }

        hasColorTransitioned = true
        colorTransitionTimestamp = Date().timeIntervalSince1970

        gradientCanvas.transitionToColors(
            topColor: currentTheme.targetHue,
            bottomColor: currentTheme.targetHue.darker(by: 0.2),
            duration: 0.2
        )

        instructionLabel.text = "TAP NOW!"
        instructionLabel.fontSize = calculateFontSize(base: 28)

        SensoryOrchestrator.shared.playColorTransitionSound()
        SensoryOrchestrator.shared.triggerMediumHaptic()

        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        instructionLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAwaitingColorTransition && !isPausedForDialog else { return }

        if !hasColorTransitioned {
            handlePrematureTouch()
        } else {
            let currentTimestamp = Date().timeIntervalSince1970
            let reactionDuration = (currentTimestamp - colorTransitionTimestamp) * 1000
            handleValidTouch(reactionTime: reactionDuration)
        }

        isAwaitingColorTransition = false
    }

    private func handlePrematureTouch() {
        instructionLabel.text = "Too Early! Game Over"
        instructionLabel.fontColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)

        SensoryOrchestrator.shared.playFailureSound()
        SensoryOrchestrator.shared.triggerErrorHaptic()

        let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shakeRight = SKAction.moveBy(x: 20, y: 0, duration: 0.05)
        let shakeBack = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shake = SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight, shakeBack])
        instructionLabel.run(shake)

        // Record stats
        PersistenceOrchestrator.shared.recordConsecutiveStreak(consecutiveStreak)
        PersistenceOrchestrator.shared.recordSupremeScore(totalScore)
        PersistenceOrchestrator.shared.recordLeaderboardScore(totalScore)

        let waitAction = SKAction.wait(forDuration: 2.0)
        let concludeAction = SKAction.run { [weak self] in
            self?.concludeGame()
        }
        run(SKAction.sequence([waitAction, concludeAction]))
    }

    private func handleValidTouch(reactionTime: Double) {
        consecutiveStreak += 1
        comboLabel.text = "Streak: \(consecutiveStreak)"

        let rating = VelocityConfiguration.VelocityRating.evaluate(milliseconds: reactionTime)
        let baseScore = max(0, VelocityConfiguration.maximumBaseScore - Int(reactionTime))
        let roundScore = baseScore * consecutiveStreak
        totalScore += roundScore

        scoreLabel.text = "Score: \(totalScore)"

        instructionLabel.text = "\(Int(reactionTime))ms - \(rating.rawValue)"
        instructionLabel.fontColor = getColorForRating(rating)

        PersistenceOrchestrator.shared.recordReactionDuration(reactionTime, wasTriumphant: true)

        SensoryOrchestrator.shared.playTriumphSound()
        SensoryOrchestrator.shared.triggerSuccessHaptic()

        if consecutiveStreak % 5 == 0 {
            SensoryOrchestrator.shared.playConsecutiveStreakSound()
            displayStreakCelebration()
        }

        // Check achievements
        _ = AccomplishmentCatalogue.evaluateAccomplishments(
            reactionTime: reactionTime,
            streak: consecutiveStreak,
            score: totalScore
        )

        let waitAction = SKAction.wait(forDuration: 1.0)
        let nextRoundAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextRoundAction]))
    }

    private func displayStreakCelebration() {
        let celebrationLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        celebrationLabel.text = "\(consecutiveStreak) STREAK!"
        celebrationLabel.fontSize = calculateFontSize(base: 22)
        celebrationLabel.fontColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        celebrationLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        celebrationLabel.zPosition = 15
        celebrationLabel.setScale(0.8)
        addChild(celebrationLabel)

        let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.6)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        celebrationLabel.run(SKAction.sequence([scaleUp, wait, fadeOut, remove]))
    }

    private func getColorForRating(_ rating: VelocityConfiguration.VelocityRating) -> UIColor {
        switch rating {
        case .transcendent: return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        case .phenomenal: return UIColor(red: 0.3, green: 0.9, blue: 1.0, alpha: 1.0)
        case .exemplary: return UIColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1.0)
        case .adequate: return UIColor(red: 0.9, green: 0.9, blue: 0.4, alpha: 1.0)
        case .mediocre: return UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        case .sluggish: return UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        }
    }

    private func concludeGame() {
        let resultsDialog = EtherealDialogNode(
            title: "Endless Mode Complete",
            message: "Streak: \(consecutiveStreak)\nScore: \(totalScore)",
            size: size
        )

        resultsDialog.addButton(
            text: "Play Again",
            colors: [UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)]
        ) { [weak self] in
            self?.restartGame()
        }

        resultsDialog.addButton(
            text: "Main Menu",
            colors: [UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)]
        ) { [weak self] in
            self?.returnToMenu()
        }

        addChild(resultsDialog)
    }

    private func restartGame() {
        let newScene = EndlessVelocityArena(size: size)
        newScene.scaleMode = scaleMode
        view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showExitConfirmation() {
        isGamePaused = true
        isPausedForDialog = true

        let dialog = EtherealDialogNode(
            title: "Exit Game?",
            message: "Your progress will be lost.",
            size: size
        )

        dialog.addButton(
            text: "Continue Playing",
            colors: [UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0)],
            action: { [weak self] in
                self?.isGamePaused = false
                self?.isPausedForDialog = false
            }
        )

        dialog.addButton(
            text: "Exit to Menu",
            colors: [UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)],
            action: { [weak self] in
                self?.returnToMenu()
            }
        )

        addChild(dialog)
    }

}

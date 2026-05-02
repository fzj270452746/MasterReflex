import SpriteKit

// Classic mode game scene
class ClassicVelocityArena: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var currentTheme: VelocityConfiguration.ChromaticTheme!

    private var roundCounter: Int = 0
    private var consecutiveStreak: Int = 0
    private var totalScore: Int = 0
    private var reactionTimes: [Double] = []

    private var colorTransitionTimestamp: TimeInterval = 0
    private var isAwaitingColorTransition: Bool = false
    private var hasColorTransitioned: Bool = false

    private var comboLabel: SKLabelNode!
    private var roundLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var instructionLabel: SKLabelNode!
    private var backButton: LuminousButtonNode!
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
        comboLabel.text = "Combo x\(consecutiveStreak)"
        addChild(comboLabel)

        // Round label
        roundLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        roundLabel.fontSize = calculateFontSize(base: 18)
        roundLabel.fontColor = UIColor(white: 1.0, alpha: 0.9)
        roundLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.78)
        roundLabel.zPosition = 10
        roundLabel.text = "Round \(roundCounter)/\(VelocityConfiguration.classicRoundQuantity)"
        addChild(roundLabel)

        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = calculateFontSize(base: 22)
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
        guard roundCounter < VelocityConfiguration.classicRoundQuantity else {
            concludeGame()
            return
        }

        roundCounter += 1
        roundLabel.text = "Round \(roundCounter)/\(VelocityConfiguration.classicRoundQuantity)"
        instructionLabel.text = "Wait for color change..."
        instructionLabel.alpha = 1.0

        hasColorTransitioned = false
        isAwaitingColorTransition = true

        // Reset to initial color
        gradientCanvas.transitionToColors(
            topColor: currentTheme.initialHue,
            bottomColor: currentTheme.initialHue.darker(by: 0.2),
            duration: 0.3
        )

        // Schedule color transition
        let randomDelay = Double.random(
            in: VelocityConfiguration.minimumDelayInterval...VelocityConfiguration.maximumDelayInterval
        )

        let waitAction = SKAction.wait(forDuration: randomDelay)
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

        // Flash effect
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        instructionLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAwaitingColorTransition && !isPausedForDialog else { return }

        if !hasColorTransitioned {
            // Tapped too early
            handlePrematureTouch()
        } else {
            // Calculate reaction time
            let currentTimestamp = Date().timeIntervalSince1970
            let reactionDuration = (currentTimestamp - colorTransitionTimestamp) * 1000 // Convert to milliseconds
            handleValidTouch(reactionTime: reactionDuration)
        }

        isAwaitingColorTransition = false
    }

    private func handlePrematureTouch() {
        consecutiveStreak = 0
        comboLabel.text = "Combo x\(consecutiveStreak)"

        instructionLabel.text = "Too Early!"
        instructionLabel.fontColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)

        SensoryOrchestrator.shared.playFailureSound()
        SensoryOrchestrator.shared.triggerErrorHaptic()

        // Shake animation
        let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shakeRight = SKAction.moveBy(x: 20, y: 0, duration: 0.05)
        let shakeCenter = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let shakeSequence = SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight, shakeCenter])
        instructionLabel.run(shakeSequence)

        let waitAction = SKAction.wait(forDuration: 1.5)
        let nextRoundAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextRoundAction]))
    }

    private func handleValidTouch(reactionTime: Double) {
        consecutiveStreak += 1
        reactionTimes.append(reactionTime)

        // Calculate score
        let baseScore = max(0, VelocityConfiguration.maximumBaseScore - Int(reactionTime))
        let finalScore = baseScore * consecutiveStreak
        totalScore += finalScore

        // Update labels
        comboLabel.text = "Combo x\(consecutiveStreak)"
        scoreLabel.text = "Score: \(totalScore)"

        // Get rating
        let rating = VelocityConfiguration.VelocityRating.evaluate(milliseconds: reactionTime)
        instructionLabel.text = "\(Int(reactionTime))ms - \(rating.rawValue)"
        instructionLabel.fontColor = getRatingColor(rating)

        // Play feedback
        SensoryOrchestrator.shared.playTriumphSound()
        SensoryOrchestrator.shared.triggerSuccessHaptic()

        if consecutiveStreak > 1 {
            SensoryOrchestrator.shared.playConsecutiveStreakSound()
        }

        // Animate combo
        if consecutiveStreak > 1 {
            let scaleUp = SKAction.scale(to: 1.3, duration: 0.15)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.15)
            comboLabel.run(SKAction.sequence([scaleUp, scaleDown]))
        }

        // Record statistics
        PersistenceOrchestrator.shared.recordReactionDuration(reactionTime, wasTriumphant: true)
        PersistenceOrchestrator.shared.recordConsecutiveStreak(consecutiveStreak)

        // Check achievements
        let newAchievements = AccomplishmentCatalogue.evaluateAccomplishments(
            reactionTime: reactionTime,
            streak: consecutiveStreak,
            score: totalScore
        )

        if !newAchievements.isEmpty {
            displayAchievementNotification(newAchievements.first!)
        }

        let waitAction = SKAction.wait(forDuration: 1.5)
        let nextRoundAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextRoundAction]))
    }

    private func getRatingColor(_ rating: VelocityConfiguration.VelocityRating) -> UIColor {
        switch rating {
        case .transcendent: return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        case .phenomenal: return UIColor(red: 0.3, green: 0.9, blue: 1.0, alpha: 1.0)
        case .exemplary: return UIColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1.0)
        case .adequate: return UIColor(red: 0.9, green: 0.9, blue: 0.4, alpha: 1.0)
        case .mediocre: return UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        case .sluggish: return UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        }
    }

    private func displayAchievementNotification(_ achievement: AccomplishmentCatalogue.AccomplishmentIdentifier) {
        let notificationLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        notificationLabel.text = "Achievement: \(achievement.title)"
        notificationLabel.fontSize = calculateFontSize(base: 20)
        notificationLabel.fontColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        notificationLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        notificationLabel.zPosition = 20
        notificationLabel.alpha = 0
        addChild(notificationLabel)

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        notificationLabel.run(SKAction.sequence([fadeIn, wait, fadeOut, remove]))
    }

    private func concludeGame() {
        // Calculate statistics
        let averageReaction = reactionTimes.reduce(0, +) / Double(reactionTimes.count)
        let fastestReaction = reactionTimes.min() ?? 0

        // Record score
        PersistenceOrchestrator.shared.recordLeaderboardScore(totalScore)
        PersistenceOrchestrator.shared.recordSupremeScore(totalScore)

        // Show results dialog
        let resultsDialog = EtherealDialogNode(
            title: "Game Complete!",
            message: "Average: \(Int(averageReaction))ms\nFastest: \(Int(fastestReaction))ms\nScore: \(totalScore)",
            size: size
        )

        resultsDialog.addButton(text: "Play Again", colors: [UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0)]) { [weak self] in
            self?.restartGame()
        }

        resultsDialog.addButton(text: "Main Menu", colors: [UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)]) { [weak self] in
            self?.returnToMenu()
        }

        addChild(resultsDialog)
    }

    private func restartGame() {
        roundCounter = 0
        consecutiveStreak = 0
        totalScore = 0
        reactionTimes = []
        comboLabel.text = "Combo x0"
        scoreLabel.text = "Score: 0"
        initiateNextRound()
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showExitConfirmation() {
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

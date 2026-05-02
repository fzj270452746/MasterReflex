import SpriteKit

// Mind Trap mode with deception mechanics
class MindTrapVelocityArena: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var currentTheme: VelocityConfiguration.ChromaticTheme!

    private var roundCounter: Int = 0
    private var consecutiveStreak: Int = 0
    private var totalScore: Int = 0

    private var colorTransitionTimestamp: TimeInterval = 0
    private var isAwaitingColorTransition: Bool = false
    private var hasColorTransitioned: Bool = false
    private var isDeceptionActive: Bool = false

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

        comboLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        comboLabel.fontSize = calculateFontSize(base: 28)
        comboLabel.fontColor = .white
        comboLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        comboLabel.zPosition = 10
        comboLabel.text = "Combo x\(consecutiveStreak)"
        addChild(comboLabel)

        roundLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        roundLabel.fontSize = calculateFontSize(base: 18)
        roundLabel.fontColor = UIColor(white: 1.0, alpha: 0.9)
        roundLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.78)
        roundLabel.zPosition = 10
        roundLabel.text = "Round \(roundCounter)"
        addChild(roundLabel)

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = calculateFontSize(base: 22)
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.15)
        scoreLabel.zPosition = 10
        scoreLabel.text = "Score: \(totalScore)"
        addChild(scoreLabel)

        instructionLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        instructionLabel.fontSize = calculateFontSize(base: 18)
        instructionLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        instructionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        instructionLabel.zPosition = 10
        instructionLabel.text = "Tap only on target color!"
        addChild(instructionLabel)
    }

    private func initiateNextRound() {
        roundCounter += 1
        roundLabel.text = "Round \(roundCounter)"
        instructionLabel.text = "Wait for target color..."
        instructionLabel.fontSize = calculateFontSize(base: 18)
        instructionLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        instructionLabel.alpha = 1.0

        hasColorTransitioned = false
        isAwaitingColorTransition = true
        isDeceptionActive = false

        gradientCanvas.transitionToColors(
            topColor: currentTheme.initialHue,
            bottomColor: currentTheme.initialHue.darker(by: 0.2),
            duration: 0.3
        )

        let shouldUseDeception = roundCounter >= VelocityConfiguration.deceptionActivationRound && Bool.random()

        let randomDelay = Double.random(
            in: VelocityConfiguration.minimumDelayInterval...VelocityConfiguration.maximumDelayInterval
        )

        if shouldUseDeception {
            executeDeceptionSequence(afterDelay: randomDelay)
        } else {
            let waitAction = SKAction.wait(forDuration: randomDelay)
            let transitionAction = SKAction.run { [weak self] in
                self?.executeColorTransition()
            }
            run(SKAction.sequence([waitAction, transitionAction]))
        }
    }

    private func executeDeceptionSequence(afterDelay delay: TimeInterval) {
        let deceptionType = Int.random(in: 0...2)

        switch deceptionType {
        case 0:
            executeEphemeralColorDeception(afterDelay: delay)
        case 1:
            executeFakeFlickerDeception(afterDelay: delay)
        case 2:
            executeMultiColorDeception(afterDelay: delay)
        default:
            break
        }
    }

    private func executeEphemeralColorDeception(afterDelay delay: TimeInterval) {
        let waitAction = SKAction.wait(forDuration: delay * 0.5)
        let fakeFlashAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.isDeceptionActive = true

            self.gradientCanvas.transitionToColors(
                topColor: self.currentTheme.targetHue,
                bottomColor: self.currentTheme.targetHue.darker(by: 0.2),
                duration: 0.05
            )

            let revertAction = SKAction.wait(forDuration: VelocityConfiguration.ephemeralColorDuration)
            let backAction = SKAction.run {
                self.gradientCanvas.transitionToColors(
                    topColor: self.currentTheme.initialHue,
                    bottomColor: self.currentTheme.initialHue.darker(by: 0.2),
                    duration: 0.05
                )
                self.isDeceptionActive = false
            }
            self.run(SKAction.sequence([revertAction, backAction]))
        }

        let finalWaitAction = SKAction.wait(forDuration: delay * 0.5)
        let realTransitionAction = SKAction.run { [weak self] in
            self?.executeColorTransition()
        }

        run(SKAction.sequence([waitAction, fakeFlashAction, finalWaitAction, realTransitionAction]))
    }

    private func executeFakeFlickerDeception(afterDelay delay: TimeInterval) {
        let waitAction = SKAction.wait(forDuration: delay * 0.6)
        let flickerAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.isDeceptionActive = true

            let flash1 = SKAction.run {
                self.gradientCanvas.animateColorPulse(color: self.currentTheme.initialHue.lighter(by: 0.3), duration: 0.1)
            }
            let wait1 = SKAction.wait(forDuration: 0.15)
            let flash2 = SKAction.run {
                self.gradientCanvas.animateColorPulse(color: self.currentTheme.initialHue.lighter(by: 0.3), duration: 0.1)
            }
            let wait2 = SKAction.wait(forDuration: 0.15)
            let endDeception = SKAction.run {
                self.isDeceptionActive = false
            }

            self.run(SKAction.sequence([flash1, wait1, flash2, wait2, endDeception]))
        }

        let finalWaitAction = SKAction.wait(forDuration: delay * 0.4)
        let realTransitionAction = SKAction.run { [weak self] in
            self?.executeColorTransition()
        }

        run(SKAction.sequence([waitAction, flickerAction, finalWaitAction, realTransitionAction]))
    }

    private func executeMultiColorDeception(afterDelay delay: TimeInterval) {
        let waitAction = SKAction.wait(forDuration: delay * 0.5)
        let multiColorAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.isDeceptionActive = true

            let colors: [UIColor] = [
                UIColor(red: 0.9, green: 0.6, blue: 0.3, alpha: 1.0),
                UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0),
                UIColor(red: 0.9, green: 0.3, blue: 0.6, alpha: 1.0)
            ]

            var actions: [SKAction] = []
            for color in colors {
                let changeColor = SKAction.run {
                    self.gradientCanvas.transitionToColors(
                        topColor: color,
                        bottomColor: color.darker(by: 0.2),
                        duration: 0.1
                    )
                }
                let wait = SKAction.wait(forDuration: 0.15)
                actions.append(changeColor)
                actions.append(wait)
            }

            let resetColor = SKAction.run {
                self.gradientCanvas.transitionToColors(
                    topColor: self.currentTheme.initialHue,
                    bottomColor: self.currentTheme.initialHue.darker(by: 0.2),
                    duration: 0.1
                )
                self.isDeceptionActive = false
            }
            actions.append(resetColor)

            self.run(SKAction.sequence(actions))
        }

        let finalWaitAction = SKAction.wait(forDuration: delay * 0.5)
        let realTransitionAction = SKAction.run { [weak self] in
            self?.executeColorTransition()
        }

        run(SKAction.sequence([waitAction, multiColorAction, finalWaitAction, realTransitionAction]))
    }

    private func executeColorTransition() {
        guard isAwaitingColorTransition else { return }

        hasColorTransitioned = true
        isDeceptionActive = false
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

        if isDeceptionActive || !hasColorTransitioned {
            handleDeceivedTouch()
        } else {
            let currentTimestamp = Date().timeIntervalSince1970
            let reactionDuration = (currentTimestamp - colorTransitionTimestamp) * 1000
            handleValidTouch(reactionTime: reactionDuration)
        }

        isAwaitingColorTransition = false
    }

    private func handleDeceivedTouch() {
        consecutiveStreak = 0
        comboLabel.text = "Combo x\(consecutiveStreak)"

        instructionLabel.text = "Deceived! Too Early!"
        instructionLabel.fontColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)

        SensoryOrchestrator.shared.playFailureSound()
        SensoryOrchestrator.shared.triggerErrorHaptic()

        instructionLabel.performShakeAnimation()

        let waitAction = SKAction.wait(forDuration: 1.5)
        let nextAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextAction]))
    }

    private func handleValidTouch(reactionTime: Double) {
        consecutiveStreak += 1

        let baseScore = max(0, VelocityConfiguration.maximumBaseScore - Int(reactionTime))
        let comboMultiplier = 1 + (consecutiveStreak / 3)
        let finalScore = baseScore * comboMultiplier
        totalScore += finalScore

        comboLabel.text = "Combo x\(consecutiveStreak)"
        scoreLabel.text = "Score: \(totalScore)"

        let rating = VelocityConfiguration.VelocityRating.evaluate(milliseconds: reactionTime)
        instructionLabel.text = "\(Int(reactionTime))ms - \(rating.rawValue)!"
        instructionLabel.fontColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)

        SensoryOrchestrator.shared.playTriumphSound()
        SensoryOrchestrator.shared.triggerSuccessHaptic()

        PersistenceOrchestrator.shared.recordReactionDuration(reactionTime, wasTriumphant: true)

        if consecutiveStreak % 5 == 0 {
            SensoryOrchestrator.shared.playConsecutiveStreakSound()
            comboLabel.performPulseAnimation(scale: 1.3)
        }

        let accomplishments = AccomplishmentCatalogue.evaluateAccomplishments(
            reactionTime: reactionTime,
            streak: consecutiveStreak,
            score: totalScore
        )

        if !accomplishments.isEmpty {
            showAccomplishmentNotification(accomplishments.first!)
        }

        let waitAction = SKAction.wait(forDuration: 1.0)
        let nextAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextAction]))
    }

    private func showAccomplishmentNotification(_ accomplishment: AccomplishmentCatalogue.AccomplishmentIdentifier) {
        let notificationLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        notificationLabel.text = "Achievement: \(accomplishment.title)"
        notificationLabel.fontSize = calculateFontSize(base: 20)
        notificationLabel.fontColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
        notificationLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        notificationLabel.zPosition = 15
        notificationLabel.alpha = 0
        addChild(notificationLabel)

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()

        notificationLabel.run(SKAction.sequence([fadeIn, wait, fadeOut, remove]))
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
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

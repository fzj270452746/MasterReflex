import SpriteKit

// Grid Reflex mode with spatial reaction challenge
class GridVelocityArena: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var currentTheme: VelocityConfiguration.ChromaticTheme!

    private var gridDimension: Int = VelocityConfiguration.initialGridDimension
    private var gridCells: [[SKShapeNode]] = []
    private var targetCellPosition: (row: Int, col: Int)?

    private var levelCounter: Int = 1
    private var consecutiveStreak: Int = 0
    private var totalScore: Int = 0
    private var missedAttempts: Int = 0

    private var colorTransitionTimestamp: TimeInterval = 0
    private var isAwaitingResponse: Bool = false

    private var levelLabel: SKLabelNode!
    private var streakLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var instructionLabel: SKLabelNode!
    private var backButton: LuminousButtonNode!
    private var isPausedForDialog: Bool = false

    override func didMove(to view: SKView) {
        currentTheme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        setupGradientBackground()
        setupLabels()
        setupGrid()
        initiateNextRound()
    }

    private func setupGradientBackground() {
        gradientCanvas = GradientCanvasNode(
            size: size,
            topColor: currentTheme.initialHue.darker(by: 0.3),
            bottomColor: currentTheme.initialHue.darker(by: 0.5)
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

        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        levelLabel.fontSize = calculateFontSize(base: 22)
        levelLabel.fontColor = .white
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.88)
        levelLabel.zPosition = 10
        levelLabel.text = "Level \(levelCounter)"
        addChild(levelLabel)

        streakLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        streakLabel.fontSize = calculateFontSize(base: 18)
        streakLabel.fontColor = UIColor(white: 1.0, alpha: 0.9)
        streakLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.83)
        streakLabel.zPosition = 10
        streakLabel.text = "Streak: \(consecutiveStreak)"
        addChild(streakLabel)

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = calculateFontSize(base: 20)
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.08)
        scoreLabel.zPosition = 10
        scoreLabel.text = "Score: \(totalScore)"
        addChild(scoreLabel)

        instructionLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        instructionLabel.fontSize = calculateFontSize(base: 16)
        instructionLabel.fontColor = UIColor(white: 1.0, alpha: 0.7)
        instructionLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.14)
        instructionLabel.zPosition = 10
        instructionLabel.text = "Tap the target color!"
        addChild(instructionLabel)
    }
    private func setupGrid() {
        clearGrid()
        
        let gridSize = min(size.width, size.height * 0.6) * 0.85
        let cellSize = gridSize / CGFloat(gridDimension)
        let spacing: CGFloat = 4
        let actualCellSize = cellSize - spacing
        
        let gridStartX = (size.width - gridSize) / 2 + cellSize / 2
        let gridStartY = size.height * 0.55 - gridSize / 2 + cellSize / 2
        
        for row in 0..<gridDimension {
            var rowCells: [SKShapeNode] = []
            for col in 0..<gridDimension {
                let cell = SKShapeNode(rectOf: CGSize(width: actualCellSize, height: actualCellSize), cornerRadius: 8)
                cell.fillColor = UIColor(white: 0.3, alpha: 0.5)
                cell.strokeColor = UIColor(white: 0.5, alpha: 0.3)
                cell.lineWidth = 2
                cell.position = CGPoint(
                    x: gridStartX + CGFloat(col) * cellSize,
                    y: gridStartY + CGFloat(row) * cellSize
                )
                cell.zPosition = 5
                cell.name = "cell_\(row)_\(col)"
                addChild(cell)
                rowCells.append(cell)
            }
            gridCells.append(rowCells)
        }
    }
    
    private func clearGrid() {
        for row in gridCells {
            for cell in row {
                cell.removeFromParent()
            }
        }
        gridCells.removeAll()
    }
    
    private func initiateNextRound() {

        guard !gridCells.isEmpty && gridCells.count == gridDimension else {
            return
        }

        isAwaitingResponse = true
        colorTransitionTimestamp = Date().timeIntervalSince1970

        resetAllCells()

        let targetRow = Int.random(in: 0..<gridDimension)
        let targetCol = Int.random(in: 0..<gridDimension)
        targetCellPosition = (targetRow, targetCol)


        let shouldAddDistractors = levelCounter >= 2

        if shouldAddDistractors {
            addDistractorCells()
        }

        let targetCell = gridCells[targetRow][targetCol]
        targetCell.fillColor = currentTheme.targetHue
        targetCell.strokeColor = currentTheme.targetHue.lighter(by: 0.2)

        let pulseUp = SKAction.scale(to: 1.1, duration: 0.3)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        targetCell.run(SKAction.repeatForever(pulse), withKey: "pulse")

        SensoryOrchestrator.shared.playColorTransitionSound()
        SensoryOrchestrator.shared.triggerLightHaptic()

        let timeoutAction = SKAction.wait(forDuration: VelocityConfiguration.gridResponseWindow)
        let missAction = SKAction.run { [weak self] in
            self?.handleMissedTarget()
        }
        run(SKAction.sequence([timeoutAction, missAction]), withKey: "timeout")

    }
    
    private func resetAllCells() {
        for row in gridCells {
            for cell in row {
                cell.removeAction(forKey: "pulse")
                cell.fillColor = UIColor(white: 0.3, alpha: 0.5)
                cell.strokeColor = UIColor(white: 0.5, alpha: 0.3)
                cell.setScale(1.0)
            }
        }
    }
    
    private func addDistractorCells() {
        let distractorCount = min(gridDimension * gridDimension - 1, 3)
        var usedPositions = Set<String>()

        if let target = targetCellPosition {
            usedPositions.insert("\(target.row)_\(target.col)")
        }

        var addedDistractors = 0
        while addedDistractors < distractorCount {
            let row = Int.random(in: 0..<gridDimension)
            let col = Int.random(in: 0..<gridDimension)
            let key = "\(row)_\(col)"

            if usedPositions.contains(key) { continue }

            usedPositions.insert(key)
            let cell = gridCells[row][col]
            let distractorColor = generateDistractorColor()
            cell.fillColor = distractorColor
            cell.strokeColor = distractorColor.lighter(by: 0.2)
            addedDistractors += 1
        }
    }
    
    private func generateDistractorColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.9, green: 0.6, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0),
            UIColor(red: 0.9, green: 0.3, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1.0)
        ]
        return colors.randomElement() ?? .gray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard isAwaitingResponse && !isPausedForDialog, let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let cellName = node.name, cellName.hasPrefix("cell_") {
                let components = cellName.components(separatedBy: "_")
                if components.count == 3,
                   let row = Int(components[1]),
                   let col = Int(components[2]) {
                    handleCellTap(row: row, col: col)
                    return
                }
            }
        }
    }
    
    private func handleCellTap(row: Int, col: Int) {

        removeAction(forKey: "timeout")
        isAwaitingResponse = false

        guard let target = targetCellPosition else { return }

        if row == target.row && col == target.col {
            let currentTimestamp = Date().timeIntervalSince1970
            let reactionDuration = (currentTimestamp - colorTransitionTimestamp) * 1000
            handleCorrectTap(reactionTime: reactionDuration)
        } else {
            handleIncorrectTap()
        }
    }
    
    private func handleCorrectTap(reactionTime: Double) {
        consecutiveStreak += 1

        let baseScore = max(0, VelocityConfiguration.maximumBaseScore - Int(reactionTime))
        let comboMultiplier = 1 + (consecutiveStreak / 5)
        let finalScore = baseScore * comboMultiplier
        totalScore += finalScore

        streakLabel.text = "Streak: \(consecutiveStreak)"
        scoreLabel.text = "Score: \(totalScore)"

        let rating = VelocityConfiguration.VelocityRating.evaluate(milliseconds: reactionTime)
        instructionLabel.text = "\(Int(reactionTime))ms - \(rating.rawValue)!"
        instructionLabel.fontColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)

        SensoryOrchestrator.shared.playTriumphSound()
        SensoryOrchestrator.shared.triggerSuccessHaptic()

        PersistenceOrchestrator.shared.recordReactionDuration(reactionTime, wasTriumphant: true)

        if consecutiveStreak % 10 == 0 {
            levelUp()
        }

        // Remove any pending next round actions
        removeAction(forKey: "nextRound")

        let waitAction = SKAction.wait(forDuration: 0.8)
        let nextAction = SKAction.run { [weak self] in
            self?.initiateNextRound()
        }
        run(SKAction.sequence([waitAction, nextAction]), withKey: "nextRound")
    }
    
    private func handleIncorrectTap() {
        consecutiveStreak = 0
        missedAttempts += 1

        streakLabel.text = "Streak: \(consecutiveStreak)"
        instructionLabel.text = "Wrong Cell!"
        instructionLabel.fontColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)

        SensoryOrchestrator.shared.playFailureSound()
        SensoryOrchestrator.shared.triggerErrorHaptic()

        if missedAttempts >= 3 {
            concludeGame()
        } else {
            removeAction(forKey: "nextRound")
            let waitAction = SKAction.wait(forDuration: 1.0)
            let nextAction = SKAction.run { [weak self] in
                self?.initiateNextRound()
            }
            run(SKAction.sequence([waitAction, nextAction]), withKey: "nextRound")
        }
    }
    
    private func handleMissedTarget() {
        guard isAwaitingResponse else { return }

        isAwaitingResponse = false
        consecutiveStreak = 0
        missedAttempts += 1

        streakLabel.text = "Streak: \(consecutiveStreak)"
        instructionLabel.text = "Too Slow!"
        instructionLabel.fontColor = UIColor(red: 0.9, green: 0.5, blue: 0.3, alpha: 1.0)

        SensoryOrchestrator.shared.playFailureSound()
        SensoryOrchestrator.shared.triggerErrorHaptic()

        if missedAttempts >= 3 {
            concludeGame()
        } else {
            removeAction(forKey: "nextRound")
            let waitAction = SKAction.wait(forDuration: 1.0)
            let nextAction = SKAction.run { [weak self] in
                self?.initiateNextRound()
            }
            run(SKAction.sequence([waitAction, nextAction]), withKey: "nextRound")
        }
    }
    
    private func levelUp() {
        levelCounter += 1
        levelLabel.text = "Level \(levelCounter)"

        if levelCounter % 3 == 0 && gridDimension < 5 {
            gridDimension += 1
            setupGrid()
        }

        SensoryOrchestrator.shared.playConsecutiveStreakSound()
        SensoryOrchestrator.shared.triggerHeavyHaptic()

        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        levelLabel.run(SKAction.sequence([scaleUp, scaleDown]))

        // Show level up message
        instructionLabel.text = "Level Up!"
        instructionLabel.fontColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    }
    
    private func concludeGame() {
        removeAction(forKey: "timeout")
        
        PersistenceOrchestrator.shared.recordSupremeScore(totalScore)
        PersistenceOrchestrator.shared.recordConsecutiveStreak(consecutiveStreak)
        PersistenceOrchestrator.shared.recordLeaderboardScore(totalScore)
        
        let accomplishments = AccomplishmentCatalogue.evaluateAccomplishments(
            reactionTime: 0,
            streak: consecutiveStreak,
            score: totalScore
        )
        
        let dialog = EtherealDialogNode(
            title: "Game Over",
            message: "Level: \(levelCounter)\nScore: \(totalScore)\nBest Streak: \(consecutiveStreak)",
            size: size
        )
        
        if !accomplishments.isEmpty {
            for accomplishment in accomplishments {
                let achievement = AccomplishmentCatalogue.AccomplishmentIdentifier(rawValue: accomplishment.rawValue)
                if let achievement = achievement {
                    dialog.addButton(
                        text: "Achievement: \(achievement.title)",
                        colors: [UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)],
                        action: {}
                    )
                }
            }
        }
        
        dialog.addButton(
            text: "Play Again",
            colors: [UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0)],
            action: { [weak self] in
                self?.restartGame()
            }
        )
        
        dialog.addButton(
            text: "Main Menu",
            colors: [UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)],
            action: { [weak self] in
                self?.returnToMenu()
            }
        )
        
        addChild(dialog)
    }
    
    private func restartGame() {
        let newScene = GridVelocityArena(size: size)
        newScene.scaleMode = scaleMode
        view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    private func showExitConfirmation() {
        removeAction(forKey: "timeout")
        isPausedForDialog = true
        isAwaitingResponse = false

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
                self?.initiateNextRound()
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

import SpriteKit
import UIKit

// Statistics and leaderboard scene
class StatisticalPanoramaVista: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var titleLabel: SKLabelNode!
    private var segmentedControl: SKNode!
    private var contentContainer: SKNode!
    private var isShowingLeaderboard = false

    override func didMove(to view: SKView) {
        let theme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        gradientCanvas = GradientCanvasNode(
            size: size,
            topColor: theme.initialHue.darker(by: 0.2),
            bottomColor: theme.targetHue.darker(by: 0.3)
        )
        addChild(gradientCanvas)

        setupTitle()
        setupSegmentedControl()
        setupContent()
        displayStatistics()
    }

    private func setupTitle() {
        let backButton = LuminousButtonNode(
            text: "← Back",
            size: CGSize(width: 100, height: 40),
            gradientColors: [UIColor(white: 0.3, alpha: 0.8)]
        )
        backButton.position = CGPoint(x: 70, y: size.height * 0.92)
        backButton.zPosition = 10
        backButton.setActionHandler { [weak self] in
            self?.returnToMenu()
        }
        addChild(backButton)

        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "Your Statistics"
        titleLabel.fontSize = calculateFontSize(base: 32)
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 130)
        titleLabel.zPosition = 10
        addChild(titleLabel)
    }

    private func setupSegmentedControl() {
        segmentedControl = SKNode()
        segmentedControl.position = CGPoint(x: size.width / 2, y: size.height - 185)
        segmentedControl.zPosition = 10
        addChild(segmentedControl)

        let segmentWidth = size.width * 0.36
        let segmentHeight: CGFloat = 42

        let statsButton = LuminousButtonNode(
            text: "Stats",
            size: CGSize(width: segmentWidth, height: segmentHeight),
            gradientColors: [UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0)]
        )
        statsButton.position = CGPoint(x: -segmentWidth * 0.55, y: 0)
        statsButton.setActionHandler { [weak self] in
            self?.switchToStatistics()
        }
        segmentedControl.addChild(statsButton)

        let leaderboardButton = LuminousButtonNode(
            text: "Leaderboard",
            size: CGSize(width: segmentWidth, height: segmentHeight),
            gradientColors: [UIColor(red: 0.85, green: 0.55, blue: 0.2, alpha: 1.0)]
        )
        leaderboardButton.position = CGPoint(x: segmentWidth * 0.55, y: 0)
        leaderboardButton.setActionHandler { [weak self] in
            self?.switchToLeaderboard()
        }
        segmentedControl.addChild(leaderboardButton)
    }

    private func setupContent() {
        contentContainer = SKNode()
        contentContainer.position = CGPoint(x: size.width / 2, y: size.height - 250)
        addChild(contentContainer)
    }

    private func switchToStatistics() {
        guard isShowingLeaderboard else { return }
        isShowingLeaderboard = false
        clearContent()
        displayStatistics()
    }

    private func switchToLeaderboard() {
        guard !isShowingLeaderboard else { return }
        isShowingLeaderboard = true
        clearContent()
        displayLeaderboard()
    }

    private func clearContent() {
        contentContainer.removeAllChildren()
    }

    private func displayStatistics() {
        let statsContainer = SKNode()
        contentContainer.addChild(statsContainer)

        let bottomY = size.height * 0.05
        let cardCount = 7
        let availableHeight = (size.height - 250) - bottomY
        let cardSpacing = availableHeight / CGFloat(cardCount - 1)
        let cardHeight = min(80, cardSpacing * 0.70)

        let persistence = PersistenceOrchestrator.shared
        let fastestReaction = persistence.retrieveSwiftestReaction()
        let averageReaction = persistence.retrieveAverageReactionDuration()
        let totalAttempts = persistence.retrieveTotalAttempts()
        let successRate = persistence.calculateTriumphRate()
        let highScore = persistence.retrieveSupremeScore()
        let longestStreak = persistence.retrieveLongestStreak()
        let energyPoints = persistence.retrieveEnergyPoints()

        var yOffset: CGFloat = 0

        let fastestCard = createStatCard(
            icon: "bolt.fill",
            title: "Fastest Reaction",
            value: fastestReaction > 0 ? "\(Int(fastestReaction)) ms" : "N/A",
            color: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0),
            cardHeight: cardHeight
        )
        fastestCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(fastestCard)
        yOffset -= cardSpacing

        let averageCard = createStatCard(
            icon: "chart.bar.fill",
            title: "Average Reaction",
            value: averageReaction > 0 ? "\(Int(averageReaction)) ms" : "N/A",
            color: UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0),
            cardHeight: cardHeight
        )
        averageCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(averageCard)
        yOffset -= cardSpacing

        let scoreCard = createStatCard(
            icon: "trophy.fill",
            title: "High Score",
            value: "\(highScore)",
            color: UIColor(red: 0.7, green: 0.3, blue: 0.8, alpha: 1.0),
            cardHeight: cardHeight
        )
        scoreCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(scoreCard)
        yOffset -= cardSpacing

        let streakCard = createStatCard(
            icon: "flame.fill",
            title: "Longest Streak",
            value: "\(longestStreak)",
            color: UIColor(red: 0.9, green: 0.4, blue: 0.3, alpha: 1.0),
            cardHeight: cardHeight
        )
        streakCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(streakCard)
        yOffset -= cardSpacing

        let attemptsCard = createStatCard(
            icon: "target",
            title: "Total Attempts",
            value: "\(totalAttempts)",
            color: UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0),
            cardHeight: cardHeight
        )
        attemptsCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(attemptsCard)
        yOffset -= cardSpacing

        let successCard = createStatCard(
            icon: "checkmark.circle.fill",
            title: "Success Rate",
            value: String(format: "%.1f%%", successRate),
            color: UIColor(red: 0.5, green: 0.7, blue: 0.4, alpha: 1.0),
            cardHeight: cardHeight
        )
        successCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(successCard)
        yOffset -= cardSpacing

        let energyCard = createStatCard(
            icon: "bolt.fill",
            title: "Energy Points",
            value: "\(energyPoints)",
            color: UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 1.0),
            cardHeight: cardHeight
        )
        energyCard.position = CGPoint(x: 0, y: yOffset)
        statsContainer.addChild(energyCard)
    }

    private func displayLeaderboard() {
        let leaderboardContainer = SKNode()
        contentContainer.addChild(leaderboardContainer)

        let scores = PersistenceOrchestrator.shared.retrieveLeaderboardScores()

        guard !scores.isEmpty else {
            let emptyLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
            emptyLabel.text = "No scores yet. Play a game to enter the leaderboard."
            emptyLabel.fontSize = calculateFontSize(base: 18)
            emptyLabel.fontColor = UIColor(white: 0.92, alpha: 1.0)
            emptyLabel.preferredMaxLayoutWidth = size.width * 0.78
            emptyLabel.numberOfLines = 0
            emptyLabel.verticalAlignmentMode = .center
            leaderboardContainer.addChild(emptyLabel)
            return
        }

        let headerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        headerLabel.text = "Top Players"
        headerLabel.fontSize = calculateFontSize(base: 26)
        headerLabel.fontColor = .white
        headerLabel.position = CGPoint(x: 0, y: 0)
        leaderboardContainer.addChild(headerLabel)

        var yOffset: CGFloat = -40
        let rowHeight: CGFloat = 58

        for (index, score) in scores.enumerated() {
            let row = createLeaderboardRow(rank: index + 1, score: score, rowHeight: rowHeight)
            row.position = CGPoint(x: 0, y: yOffset)
            leaderboardContainer.addChild(row)
            yOffset -= rowHeight + 12
        }
    }

    private func createLeaderboardRow(rank: Int, score: Int, rowHeight: CGFloat) -> SKNode {
        let row = SKNode()
        let rowWidth = size.width * 0.85

        let background = SKShapeNode(rectOf: CGSize(width: rowWidth, height: rowHeight), cornerRadius: 12)
        background.fillColor = UIColor(white: 1.0, alpha: 0.12)
        background.strokeColor = UIColor(white: 1.0, alpha: 0.18)
        background.lineWidth = 1.5
        row.addChild(background)

        if rank <= 3, let badgeImage = UIImage(named: "top\(rank)") {
            let badgeNode = SKSpriteNode(texture: SKTexture(image: badgeImage))
            badgeNode.size = CGSize(width: 34, height: 34)
            badgeNode.position = CGPoint(x: -rowWidth * 0.4, y: 0)
            row.addChild(badgeNode)
        } else {
            let rankLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
            rankLabel.text = "#\(rank)"
            rankLabel.fontSize = calculateFontSize(base: 20)
            rankLabel.fontColor = UIColor(white: 0.95, alpha: 1.0)
            rankLabel.horizontalAlignmentMode = .left
            rankLabel.position = CGPoint(x: -rowWidth * 0.43, y: -8)
            row.addChild(rankLabel)
        }

        let playerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playerLabel.text = rank == 1 ? "Champion" : "Player \(rank)"
        playerLabel.fontSize = calculateFontSize(base: 18)
        playerLabel.fontColor = .white
        playerLabel.horizontalAlignmentMode = .left
        playerLabel.position = CGPoint(x: -rowWidth * 0.28, y: 4)
        row.addChild(playerLabel)

        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        subtitleLabel.text = rank <= 3 ? "Top Rank" : "Leaderboard Entry"
        subtitleLabel.fontSize = calculateFontSize(base: 13)
        subtitleLabel.fontColor = UIColor(white: 0.82, alpha: 1.0)
        subtitleLabel.horizontalAlignmentMode = .left
        subtitleLabel.position = CGPoint(x: -rowWidth * 0.28, y: -16)
        row.addChild(subtitleLabel)

        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "\(score) pts"
        scoreLabel.fontSize = calculateFontSize(base: 22)
        scoreLabel.fontColor = UIColor(red: 0.98, green: 0.82, blue: 0.28, alpha: 1.0)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: rowWidth * 0.42, y: -8)
        row.addChild(scoreLabel)

        return row
    }

    private func createStatCard(icon: String, title: String, value: String, color: UIColor, cardHeight: CGFloat = 80) -> SKNode {
        let card = SKNode()
        let cardWidth = size.width * 0.85

        let background = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 12)
        background.fillColor = color.withAlphaComponent(0.3)
        background.strokeColor = color
        background.lineWidth = 2
        card.addChild(background)

        let iconNode = createSymbolNode(symbolName: icon, pointSize: min(36, cardHeight * 0.5), color: color)
        iconNode.position = CGPoint(x: -cardWidth * 0.38, y: -cardHeight * 0.06)
        card.addChild(iconNode)

        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        titleLabel.text = title
        titleLabel.fontSize = calculateFontSize(base: 16)
        titleLabel.fontColor = UIColor(white: 0.9, alpha: 1.0)
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.position = CGPoint(x: -cardWidth * 0.28, y: cardHeight * 0.06)
        card.addChild(titleLabel)

        let valueLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        valueLabel.text = value
        valueLabel.fontSize = calculateFontSize(base: 22)
        valueLabel.fontColor = .white
        valueLabel.horizontalAlignmentMode = .left
        valueLabel.position = CGPoint(x: -cardWidth * 0.28, y: -cardHeight * 0.33)
        card.addChild(valueLabel)

        return card
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}

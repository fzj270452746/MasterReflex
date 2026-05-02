import SpriteKit

// Achievements and Skins scene
class AccomplishmentGalleryVista: SKScene {

    private var gradientCanvas: GradientCanvasNode!
    private var titleLabel: SKLabelNode!
    private var segmentedControl: SKNode!
    private var contentContainer: SKNode!

    private var isShowingAchievements: Bool = true

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
        displayAchievements()
    }

    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "Achievements & Skins"
        titleLabel.fontSize = calculateFontSize(base: 32)
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.92)
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

    private func setupSegmentedControl() {
        segmentedControl = SKNode()
        segmentedControl.position = CGPoint(x: size.width / 2, y: size.height * 0.82)
        addChild(segmentedControl)

        let achievementsButton = LuminousButtonNode(
            text: "Achievements",
            size: CGSize(width: size.width * 0.4, height: 45),
            gradientColors: [UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0)]
        )
        achievementsButton.position = CGPoint(x: -size.width * 0.22, y: 0)
        achievementsButton.setActionHandler { [weak self] in
            self?.switchToAchievements()
        }
        segmentedControl.addChild(achievementsButton)

        let skinsButton = LuminousButtonNode(
            text: "Skins",
            size: CGSize(width: size.width * 0.4, height: 45),
            gradientColors: [UIColor(red: 0.7, green: 0.3, blue: 0.8, alpha: 1.0)]
        )
        skinsButton.position = CGPoint(x: size.width * 0.22, y: 0)
        skinsButton.setActionHandler { [weak self] in
            self?.switchToSkins()
        }
        segmentedControl.addChild(skinsButton)
    }

    private func setupContent() {
        contentContainer = SKNode()
        contentContainer.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(contentContainer)
    }

    private func switchToAchievements() {
        guard !isShowingAchievements else { return }
        isShowingAchievements = true
        clearContent()
        displayAchievements()
    }

    private func switchToSkins() {
        guard isShowingAchievements else { return }
        isShowingAchievements = false
        clearContent()
        displaySkins()
    }

    private func clearContent() {
        contentContainer.removeAllChildren()
    }

    private func displayAchievements() {
        let accomplished = PersistenceOrchestrator.shared.retrieveAccomplishedAchievements()
        let allAchievements = AccomplishmentCatalogue.AccomplishmentIdentifier.allCases

        var yOffset: CGFloat = size.height * 0.25

        for achievement in allAchievements {
            let isUnlocked = accomplished.contains(achievement.rawValue)

            let achievementCard = createAchievementCard(
                achievement: achievement,
                isUnlocked: isUnlocked
            )
            achievementCard.position = CGPoint(x: 0, y: yOffset)
            contentContainer.addChild(achievementCard)

            yOffset -= 90
        }
    }

    private func createAchievementCard(achievement: AccomplishmentCatalogue.AccomplishmentIdentifier, isUnlocked: Bool) -> SKNode {
        let card = SKNode()

        let cardWidth = size.width * 0.85
        let cardHeight: CGFloat = 75

        let background = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 12)
        background.fillColor = isUnlocked ? UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 0.9) : UIColor(white: 0.2, alpha: 0.5)
        background.strokeColor = isUnlocked ? UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0) : UIColor(white: 0.3, alpha: 0.5)
        background.lineWidth = 2
        card.addChild(background)

        let iconNode = createSymbolNode(
            symbolName: isUnlocked ? "trophy.fill" : "lock.fill",
            pointSize: 30,
            color: isUnlocked ? UIColor(red: 0.95, green: 0.78, blue: 0.2, alpha: 1.0) : UIColor(white: 0.6, alpha: 1.0)
        )
        iconNode.position = CGPoint(x: -cardWidth * 0.38, y: -2)
        card.addChild(iconNode)

        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = achievement.title
        titleLabel.fontSize = calculateFontSize(base: 18)
        titleLabel.fontColor = isUnlocked ? .white : UIColor(white: 0.5, alpha: 1.0)
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.position = CGPoint(x: -cardWidth * 0.28, y: 8)
        card.addChild(titleLabel)

        let descLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        descLabel.text = achievement.description
        descLabel.fontSize = calculateFontSize(base: 14)
        descLabel.fontColor = isUnlocked ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)
        descLabel.horizontalAlignmentMode = .left
        descLabel.position = CGPoint(x: -cardWidth * 0.28, y: -15)
        card.addChild(descLabel)

        let rewardLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        rewardLabel.text = "+\(achievement.energyReward) Energy"
        rewardLabel.fontSize = calculateFontSize(base: 16)
        rewardLabel.fontColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
        rewardLabel.horizontalAlignmentMode = .right
        rewardLabel.position = CGPoint(x: cardWidth * 0.4, y: -8)
        card.addChild(rewardLabel)

        return card
    }

    private func displaySkins() {
        let unlockedThemes = PersistenceOrchestrator.shared.retrieveUnlockedThemes()
        let currentTheme = PersistenceOrchestrator.shared.retrieveCurrentTheme()
        let allThemes = VelocityConfiguration.ChromaticTheme.allCases
        let energyPoints = PersistenceOrchestrator.shared.retrieveEnergyPoints()

        let energyLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        energyLabel.text = "Energy: \(energyPoints)"
        energyLabel.fontSize = calculateFontSize(base: 22)
        energyLabel.fontColor = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
        energyLabel.position = CGPoint(x: 0, y: size.height * 0.3)
        contentContainer.addChild(energyLabel)

        var yOffset: CGFloat = size.height * 0.2

        for theme in allThemes {
            let isUnlocked = unlockedThemes.contains(theme.rawValue)
            let isCurrent = theme == currentTheme

            let skinCard = createSkinCard(
                theme: theme,
                isUnlocked: isUnlocked,
                isCurrent: isCurrent
            )
            skinCard.position = CGPoint(x: 0, y: yOffset)
            contentContainer.addChild(skinCard)

            yOffset -= 100
        }
    }

    private func createSkinCard(theme: VelocityConfiguration.ChromaticTheme, isUnlocked: Bool, isCurrent: Bool) -> SKNode {
        let card = SKNode()

        let cardWidth = size.width * 0.85
        let cardHeight: CGFloat = 85

        let background = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 12)
        background.fillColor = UIColor(white: 0.2, alpha: 0.8)
        background.strokeColor = isCurrent ? UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0) : UIColor(white: 0.4, alpha: 0.5)
        background.lineWidth = isCurrent ? 3 : 2
        card.addChild(background)

        let colorPreview1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 8)
        colorPreview1.fillColor = theme.initialHue
        colorPreview1.strokeColor = .clear
        colorPreview1.position = CGPoint(x: -cardWidth * 0.35, y: 0)
        card.addChild(colorPreview1)

        let colorPreview2 = SKShapeNode(rectOf: CGSize(width: 50, height: 50), cornerRadius: 8)
        colorPreview2.fillColor = theme.targetHue
        colorPreview2.strokeColor = .clear
        colorPreview2.position = CGPoint(x: -cardWidth * 0.25, y: 0)
        card.addChild(colorPreview2)

        let nameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        nameLabel.text = theme.rawValue
        nameLabel.fontSize = calculateFontSize(base: 20)
        nameLabel.fontColor = .white
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -cardWidth * 0.15, y: -8)
        card.addChild(nameLabel)

        if isCurrent {
            let currentLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
            currentLabel.text = "Active"
            currentLabel.fontSize = calculateFontSize(base: 16)
            currentLabel.fontColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
            currentLabel.horizontalAlignmentMode = .right
            currentLabel.position = CGPoint(x: cardWidth * 0.38, y: -8)
            card.addChild(currentLabel)
        } else if isUnlocked {
            let selectButton = LuminousButtonNode(
                text: "Select",
                size: CGSize(width: 90, height: 35),
                gradientColors: [UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)]
            )
            selectButton.position = CGPoint(x: cardWidth * 0.32, y: 0)
            selectButton.setActionHandler { [weak self] in
                self?.selectTheme(theme)
            }
            card.addChild(selectButton)
        } else {
            let unlockButton = LuminousButtonNode(
                text: "100 Energy",
                size: CGSize(width: 90, height: 35),
                gradientColors: [UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 1.0)]
            )
            unlockButton.position = CGPoint(x: cardWidth * 0.32, y: 0)
            unlockButton.setActionHandler { [weak self] in
                self?.unlockTheme(theme)
            }
            card.addChild(unlockButton)
        }

        return card
    }

    private func selectTheme(_ theme: VelocityConfiguration.ChromaticTheme) {
        PersistenceOrchestrator.shared.storeCurrentTheme(theme)
        SensoryOrchestrator.shared.triggerSuccessHaptic()
        clearContent()
        displaySkins()
    }

    private func unlockTheme(_ theme: VelocityConfiguration.ChromaticTheme) {
        let cost = 100
        if PersistenceOrchestrator.shared.expendEnergyPoints(cost) {
            PersistenceOrchestrator.shared.unlockChromaticTheme(theme)
            SensoryOrchestrator.shared.triggerSuccessHaptic()
            clearContent()
            displaySkins()
        } else {
            SensoryOrchestrator.shared.triggerErrorHaptic()
            showInsufficientEnergyDialog()
        }
    }

    private func showInsufficientEnergyDialog() {
        let dialog = EtherealDialogNode(
            title: "Insufficient Energy",
            message: "You need more energy points to unlock this skin. Complete achievements to earn more!",
            size: size
        )
        dialog.addButton(
            text: "OK",
            colors: [UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)],
            action: {}
        )
        addChild(dialog)
    }

    private func returnToMenu() {
        let menuScene = PrimordialMenuVista(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
    }

}

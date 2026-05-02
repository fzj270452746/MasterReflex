import UIKit

// MARK: - Core Game View (All Game Logic & UI Enclosed)

final class AetherialHeirloomSanctum: UIView {
    
    // MARK: - Opulent Data Models
    private struct AncestralRelic {
        let title: String
        let multiplierForRevenue: CGFloat
        let bonusToCulinary: CGFloat
        let bonusToHospitality: CGFloat
    }
    
    private struct EpochLog {
        let chronicle: String
        let timestamp: Date
    }
    
    // MARK: - Enigmatic Properties (Low-Frequency Lexicon)
    private var aureusReservoir: CGFloat = 1250.0          // gold
    private var renownAether: CGFloat = 380.0              // reputation/satisfaction
    private var generationalOrdinal: Int = 1                // current generation
    private var chronoAnchor: Int = 1901                    // current year
    private var culinaryProwess: CGFloat = 48.0            // dish mastery
    private var hospitablenessExcellence: CGFloat = 42.0   // service skill
    private var legacyEssencePool: CGFloat = 0.0
    private var legacyAscensionThreshold: CGFloat = 1400.0
    
    // Permanent inheritance boons
    private var perennialRevenueAugment: CGFloat = 1.0
    private var perennialCulinaryAugment: CGFloat = 1.0
    private var perennialHospitalityAugment: CGFloat = 1.0
    
    // Game state flags
    private var isInheritanceRitualActive: Bool = false
    private var isAcceleratingChronos: Bool = false
    
    // Chronicle logs
    private var temporalLogEntries: [EpochLog] = []
    
    // MARK: - Ambient UI Components (No UIStackView)
    private var ambientGradientLayer: CAGradientLayer!
    private var ornamentalBorder: UIView!
    private var aureateCoinIcon: UILabel!
    private var prestigeStarIcon: UILabel!
    private var hourglassIcon: UILabel!
    private var lineageCrestIcon: UILabel!
    
    private var aureusAmountLabel: UILabel!
    private var renownAmountLabel: UILabel!
    private var chronoYearLabel: UILabel!
    private var generationBadgeLabel: UILabel!
    private var culinaryMeterView: UIProgressView!
    private var hospitalityMeterView: UIProgressView!
    private var legacyProgressView: UIProgressView!
    private var culinaryValueLabel: UILabel!
    private var hospitalityValueLabel: UILabel!
    private var legacyValueLabel: UILabel!
    
    private var eventChronicleTextView: UITextView!
    private var compressChronosButton: UIButton!
    private var enhanceCuisineButton: UIButton!
    private var refineServiceButton: UIButton!
    private var rejuvenateSanctumButton: UIButton!
    
    private var activityOverlayView: UIView?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        orchestrateSubterraneanComponents()
        erectOrnateUI()
        invokeInitialChronicle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Secret Configuration & Layout
    private func orchestrateSubterraneanComponents() {
        backgroundColor = UIColor(red: 0.08, green: 0.06, blue: 0.12, alpha: 1.0)
        layer.cornerRadius = 42
        layer.borderWidth = 1.2
        layer.borderColor = UIColor(red: 0.85, green: 0.72, blue: 0.45, alpha: 0.8).cgColor
        
        ambientGradientLayer = CAGradientLayer()
        ambientGradientLayer.colors = [
            UIColor(red: 0.12, green: 0.09, blue: 0.21, alpha: 1.0).cgColor,
            UIColor(red: 0.05, green: 0.03, blue: 0.09, alpha: 1.0).cgColor
        ]
        ambientGradientLayer.locations = [0.0, 1.0]
        ambientGradientLayer.frame = bounds
        layer.insertSublayer(ambientGradientLayer, at: 0)
    }
    
    private func erectOrnateUI() {
        // Top resource row: coins, prestige, year, generation
        aureateCoinIcon = createIconLabel(symbol: "🪙", tint: UIColor(red: 1.0, green: 0.84, blue: 0.35, alpha: 1.0))
        aureusAmountLabel = createValueLabel()
        prestigeStarIcon = createIconLabel(symbol: "✨", tint: UIColor(red: 0.78, green: 0.62, blue: 0.94, alpha: 1.0))
        renownAmountLabel = createValueLabel()
        hourglassIcon = createIconLabel(symbol: "⏳", tint: UIColor(red: 0.52, green: 0.84, blue: 0.92, alpha: 1.0))
        chronoYearLabel = createValueLabel()
        lineageCrestIcon = createIconLabel(symbol: "👑", tint: UIColor(red: 0.96, green: 0.76, blue: 0.42, alpha: 1.0))
        generationBadgeLabel = createValueLabel()
        
        addSubview(aureateCoinIcon)
        addSubview(aureusAmountLabel)
        addSubview(prestigeStarIcon)
        addSubview(renownAmountLabel)
        addSubview(hourglassIcon)
        addSubview(chronoYearLabel)
        addSubview(lineageCrestIcon)
        addSubview(generationBadgeLabel)
        
        // Skill meters
        let culinaryTitle = createElegantLabel(text: "Culinary Prowess")
        culinaryMeterView = UIProgressView(progressViewStyle: .default)
        culinaryMeterView.trackTintColor = UIColor(white: 0.25, alpha: 1.0)
        culinaryMeterView.progressTintColor = UIColor(red: 0.98, green: 0.58, blue: 0.22, alpha: 1.0)
        culinaryMeterView.layer.cornerRadius = 6
        culinaryMeterView.clipsToBounds = true
        culinaryValueLabel = createSmallValueLabel()
        
        let hospitalityTitle = createElegantLabel(text: "Hospitality Essence")
        hospitalityMeterView = UIProgressView(progressViewStyle: .default)
        hospitalityMeterView.trackTintColor = UIColor(white: 0.25, alpha: 1.0)
        hospitalityMeterView.progressTintColor = UIColor(red: 0.32, green: 0.76, blue: 0.64, alpha: 1.0)
        hospitalityMeterView.layer.cornerRadius = 6
        hospitalityMeterView.clipsToBounds = true
        hospitalityValueLabel = createSmallValueLabel()
        
        let legacyTitle = createElegantLabel(text: "Ancestral Essence")
        legacyProgressView = UIProgressView(progressViewStyle: .default)
        legacyProgressView.trackTintColor = UIColor(white: 0.25, alpha: 1.0)
        legacyProgressView.progressTintColor = UIColor(red: 0.78, green: 0.44, blue: 0.86, alpha: 1.0)
        legacyProgressView.layer.cornerRadius = 6
        legacyProgressView.clipsToBounds = true
        legacyValueLabel = createSmallValueLabel()
        
        addSubview(culinaryTitle)
        addSubview(culinaryMeterView)
        addSubview(culinaryValueLabel)
        addSubview(hospitalityTitle)
        addSubview(hospitalityMeterView)
        addSubview(hospitalityValueLabel)
        addSubview(legacyTitle)
        addSubview(legacyProgressView)
        addSubview(legacyValueLabel)
        
        // Chronicle log (Rich text view)
        eventChronicleTextView = UITextView()
        eventChronicleTextView.backgroundColor = UIColor(red: 0.05, green: 0.03, blue: 0.1, alpha: 0.7)
        eventChronicleTextView.layer.cornerRadius = 28
        eventChronicleTextView.layer.borderWidth = 0.8
        eventChronicleTextView.layer.borderColor = UIColor(red: 0.65, green: 0.52, blue: 0.32, alpha: 0.7).cgColor
        eventChronicleTextView.textColor = UIColor(white: 0.92, alpha: 1.0)
        eventChronicleTextView.font = UIFont(name: "Georgia-Italic", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        eventChronicleTextView.isEditable = false
        eventChronicleTextView.showsVerticalScrollIndicator = true
        eventChronicleTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        addSubview(eventChronicleTextView)
        
        // Action Buttons
        compressChronosButton = createVividButton(title: "Accelerate Era", color: UIColor(red: 0.88, green: 0.48, blue: 0.25, alpha: 1.0))
        compressChronosButton.addTarget(self, action: #selector(compressChronalNexus), for: .touchUpInside)
        
        enhanceCuisineButton = createVividButton(title: "Refine Recipes", color: UIColor(red: 0.94, green: 0.62, blue: 0.22, alpha: 1.0))
        enhanceCuisineButton.addTarget(self, action: #selector(elevateGastronomicSymphony), for: .touchUpInside)
        
        refineServiceButton = createVividButton(title: "Train Stewards", color: UIColor(red: 0.28, green: 0.67, blue: 0.55, alpha: 1.0))
        refineServiceButton.addTarget(self, action: #selector(polishHospitableVirtue), for: .touchUpInside)
        
        rejuvenateSanctumButton = createVividButton(title: "Reset Timeline", color: UIColor(red: 0.45, green: 0.32, blue: 0.28, alpha: 1.0))
        rejuvenateSanctumButton.addTarget(self, action: #selector(relinquishAndRebirth), for: .touchUpInside)
        
        addSubview(compressChronosButton)
        addSubview(enhanceCuisineButton)
        addSubview(refineServiceButton)
        addSubview(rejuvenateSanctumButton)
        
        // Manual constraints (No StackView)
        setupArcaneConstraints()
        refreshMonitoryDisplays()
        updateSkillMeters()
    }
    
    private func setupArcaneConstraints() {
        [aureateCoinIcon, aureusAmountLabel, prestigeStarIcon, renownAmountLabel, hourglassIcon, chronoYearLabel, lineageCrestIcon, generationBadgeLabel, eventChronicleTextView, compressChronosButton, enhanceCuisineButton, refineServiceButton, rejuvenateSanctumButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let topGuard = safeAreaLayoutGuide.topAnchor
        
        NSLayoutConstraint.activate([
            aureateCoinIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            aureateCoinIcon.topAnchor.constraint(equalTo: topGuard, constant: 20),
            aureateCoinIcon.widthAnchor.constraint(equalToConstant: 32),
            aureateCoinIcon.heightAnchor.constraint(equalToConstant: 32),
            
            aureusAmountLabel.leadingAnchor.constraint(equalTo: aureateCoinIcon.trailingAnchor, constant: 8),
            aureusAmountLabel.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            
            prestigeStarIcon.leadingAnchor.constraint(equalTo: aureusAmountLabel.trailingAnchor, constant: 24),
            prestigeStarIcon.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            prestigeStarIcon.widthAnchor.constraint(equalToConstant: 28),
            prestigeStarIcon.heightAnchor.constraint(equalToConstant: 28),
            
            renownAmountLabel.leadingAnchor.constraint(equalTo: prestigeStarIcon.trailingAnchor, constant: 8),
            renownAmountLabel.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            
            hourglassIcon.leadingAnchor.constraint(equalTo: renownAmountLabel.trailingAnchor, constant: 24),
            hourglassIcon.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            hourglassIcon.widthAnchor.constraint(equalToConstant: 28),
            hourglassIcon.heightAnchor.constraint(equalToConstant: 28),
            
            chronoYearLabel.leadingAnchor.constraint(equalTo: hourglassIcon.trailingAnchor, constant: 8),
            chronoYearLabel.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            
            lineageCrestIcon.leadingAnchor.constraint(equalTo: chronoYearLabel.trailingAnchor, constant: 24),
            lineageCrestIcon.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            lineageCrestIcon.widthAnchor.constraint(equalToConstant: 28),
            lineageCrestIcon.heightAnchor.constraint(equalToConstant: 28),
            
            generationBadgeLabel.leadingAnchor.constraint(equalTo: lineageCrestIcon.trailingAnchor, constant: 8),
            generationBadgeLabel.centerYAnchor.constraint(equalTo: aureateCoinIcon.centerYAnchor),
            generationBadgeLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
        
        let culinaryTitle = subviews.first(where: { ($0 as? UILabel)?.text == "Culinary Prowess" })!
        let hospitalityTitle = subviews.first(where: { ($0 as? UILabel)?.text == "Hospitality Essence" })!
        let legacyTitle = subviews.first(where: { ($0 as? UILabel)?.text == "Ancestral Essence" })!
        
        culinaryTitle.translatesAutoresizingMaskIntoConstraints = false
        hospitalityTitle.translatesAutoresizingMaskIntoConstraints = false
        legacyTitle.translatesAutoresizingMaskIntoConstraints = false
        culinaryMeterView.translatesAutoresizingMaskIntoConstraints = false
        hospitalityMeterView.translatesAutoresizingMaskIntoConstraints = false
        legacyProgressView.translatesAutoresizingMaskIntoConstraints = false
        culinaryValueLabel.translatesAutoresizingMaskIntoConstraints = false
        hospitalityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        legacyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            culinaryTitle.topAnchor.constraint(equalTo: aureateCoinIcon.bottomAnchor, constant: 28),
            culinaryTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            culinaryMeterView.leadingAnchor.constraint(equalTo: culinaryTitle.trailingAnchor, constant: 18),
            culinaryMeterView.centerYAnchor.constraint(equalTo: culinaryTitle.centerYAnchor),
            culinaryMeterView.widthAnchor.constraint(equalToConstant: 160),
            culinaryMeterView.heightAnchor.constraint(equalToConstant: 12),
            culinaryValueLabel.leadingAnchor.constraint(equalTo: culinaryMeterView.trailingAnchor, constant: 14),
            culinaryValueLabel.centerYAnchor.constraint(equalTo: culinaryTitle.centerYAnchor),
            
            hospitalityTitle.topAnchor.constraint(equalTo: culinaryTitle.bottomAnchor, constant: 22),
            hospitalityTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            hospitalityMeterView.leadingAnchor.constraint(equalTo: hospitalityTitle.trailingAnchor, constant: 18),
            hospitalityMeterView.centerYAnchor.constraint(equalTo: hospitalityTitle.centerYAnchor),
            hospitalityMeterView.widthAnchor.constraint(equalToConstant: 160),
            hospitalityMeterView.heightAnchor.constraint(equalToConstant: 12),
            hospitalityValueLabel.leadingAnchor.constraint(equalTo: hospitalityMeterView.trailingAnchor, constant: 14),
            hospitalityValueLabel.centerYAnchor.constraint(equalTo: hospitalityTitle.centerYAnchor),
            
            legacyTitle.topAnchor.constraint(equalTo: hospitalityTitle.bottomAnchor, constant: 22),
            legacyTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            legacyProgressView.leadingAnchor.constraint(equalTo: legacyTitle.trailingAnchor, constant: 18),
            legacyProgressView.centerYAnchor.constraint(equalTo: legacyTitle.centerYAnchor),
            legacyProgressView.widthAnchor.constraint(equalToConstant: 160),
            legacyProgressView.heightAnchor.constraint(equalToConstant: 12),
            legacyValueLabel.leadingAnchor.constraint(equalTo: legacyProgressView.trailingAnchor, constant: 14),
            legacyValueLabel.centerYAnchor.constraint(equalTo: legacyTitle.centerYAnchor)
        ])
        
        eventChronicleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventChronicleTextView.topAnchor.constraint(equalTo: legacyTitle.bottomAnchor, constant: 32),
            eventChronicleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            eventChronicleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            eventChronicleTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let buttonRows = [compressChronosButton, enhanceCuisineButton, refineServiceButton, rejuvenateSanctumButton]
        for (idx, btn) in buttonRows.enumerated() {
            btn!.translatesAutoresizingMaskIntoConstraints = false
            let row = idx / 2
            let col = idx % 2
            let leadingOffset = col == 0 ? 28 : (bounds.width/2 + 12)
            NSLayoutConstraint.activate([
                btn!.topAnchor.constraint(equalTo: eventChronicleTextView.bottomAnchor, constant: CGFloat(28 + row * 68)),
                btn!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: col == 0 ? 28 : (frame.width > 0 ? frame.width/2 + 12 : 210)),
                btn!.widthAnchor.constraint(equalToConstant: 156),
                btn!.heightAnchor.constraint(equalToConstant: 52)
            ])
        }
        // adjust leading for second column using layout later, but safe fallback
        NSLayoutConstraint.activate([
            enhanceCuisineButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width > 0 ? frame.width/2 + 12 : 210),
            refineServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            rejuvenateSanctumButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width > 0 ? frame.width/2 + 12 : 210)
        ])
    }
    
    // MARK: - Core Game Mechanics
    
    @objc private func compressChronalNexus() {
        guard !isInheritanceRitualActive, !isAcceleratingChronos else { return }
        isAcceleratingChronos = true
        
        let yearsElapsed = Int.random(in: 1...3)
        var accumulatedRevenue: CGFloat = 0
        for _ in 0..<yearsElapsed {
            let seasonGain = computeAnnualFluctuation()
            accumulatedRevenue += seasonGain
            chronoAnchor += 1
            legacyEssencePool += seasonGain * 0.12
        }
        aureusReservoir += accumulatedRevenue
        renownAether = max(0, renownAether + accumulatedRevenue * 0.06)
        
        let chronicleMsg = "⏩ \(yearsElapsed) year(s) compressed · \(Int(accumulatedRevenue)) aurei gained"
        embedChronicleEntry(chronicleMsg)
        
        checkAndTriggerInheritanceIfNeeded()
        refreshMonitoryDisplays()
        updateSkillMeters()
        
        isAcceleratingChronos = false
    }
    
    private func computeAnnualFluctuation() -> CGFloat {
        let baseSkill = (culinaryProwess * perennialCulinaryAugment) + (hospitablenessExcellence * perennialHospitalityAugment)
        let prestigeFactor = renownAether / 250.0
        let fortune = (baseSkill * 5.2 + prestigeFactor * 28) * perennialRevenueAugment
        let variability = CGFloat.random(in: 0.75...1.48)
        let finalVal = max(12, fortune * variability)
        return finalVal.rounded()
    }
    
    @objc private func elevateGastronomicSymphony() {
        let upgradeCost: CGFloat = 140
        guard aureusReservoir >= upgradeCost else {
            embedChronicleEntry("Insufficient aurei to refine recipes")
            return
        }
        aureusReservoir -= upgradeCost
        culinaryProwess = min(100, culinaryProwess + 7)
        embedChronicleEntry("🔪 Culinary mastery increased to \(Int(culinaryProwess))")
        refreshMonitoryDisplays()
        updateSkillMeters()
    }
    
    @objc private func polishHospitableVirtue() {
        let upgradeCost: CGFloat = 125
        guard aureusReservoir >= upgradeCost else {
            embedChronicleEntry("Insufficient aurei for staff training")
            return
        }
        aureusReservoir -= upgradeCost
        hospitablenessExcellence = min(100, hospitablenessExcellence + 6)
        embedChronicleEntry("🍽️ Hospitality excellence rises to \(Int(hospitablenessExcellence))")
        refreshMonitoryDisplays()
        updateSkillMeters()
    }
    
    @objc private func relinquishAndRebirth() {
        let resetAlert = UIAlertController(title: "Renaissance of Flavors", message: "Reset all progress and begin a new lineage?", preferredStyle: .alert)
        resetAlert.addAction(UIAlertAction(title: "Embrace Renewal", style: .destructive, handler: { _ in
            self.performTotalAnnihilation()
        }))
        resetAlert.addAction(UIAlertAction(title: "Preserve Heritage", style: .cancel))
        if let parentVC = self.findViewController() {
            parentVC.present(resetAlert, animated: true)
        }
    }
    
    private func performTotalAnnihilation() {
        aureusReservoir = 1100
        renownAether = 350
        generationalOrdinal = 1
        chronoAnchor = 1901
        culinaryProwess = 45
        hospitablenessExcellence = 40
        legacyEssencePool = 0
        perennialRevenueAugment = 1.0
        perennialCulinaryAugment = 1.0
        perennialHospitalityAugment = 1.0
        legacyAscensionThreshold = 1400
        embedChronicleEntry("🕊️ Timelines converged · A new saga begins")
        refreshMonitoryDisplays()
        updateSkillMeters()
    }
    
    private func checkAndTriggerInheritanceIfNeeded() {
        if legacyEssencePool >= legacyAscensionThreshold && !isInheritanceRitualActive {
            isInheritanceRitualActive = true
            suspendUserInteractionDuringRitual(true)
            invokeHeirTransitionCeremony()
        }
    }
    
    private func invokeHeirTransitionCeremony() {
        let options: [AncestralRelic] = [
            AncestralRelic(title: "Gilded Chronometer", multiplierForRevenue: 1.28, bonusToCulinary: 0.0, bonusToHospitality: 0.0),
            AncestralRelic(title: "Phantom Recipe Grimoire", multiplierForRevenue: 0.0, bonusToCulinary: 22, bonusToHospitality: 0.0),
            AncestralRelic(title: "Elysian Service Mantle", multiplierForRevenue: 0.0, bonusToCulinary: 0.0, bonusToHospitality: 23)
        ]
        
        let selectionPanel = UIView(frame: bounds)
        selectionPanel.backgroundColor = UIColor(white: 0.0, alpha: 0.85)
        selectionPanel.layer.cornerRadius = 32
        selectionPanel.tag = 9912
        
        let panelContainer = UIView()
        panelContainer.backgroundColor = UIColor(red: 0.12, green: 0.08, blue: 0.18, alpha: 0.96)
        panelContainer.layer.cornerRadius = 48
        panelContainer.layer.borderWidth = 1.5
        panelContainer.layer.borderColor = UIColor(red: 0.82, green: 0.71, blue: 0.48, alpha: 1.0).cgColor
        panelContainer.translatesAutoresizingMaskIntoConstraints = false
        selectionPanel.addSubview(panelContainer)
        
        let titleLabel = UILabel()
        titleLabel.text = "THE CROSSROADS OF LEGACY"
        titleLabel.font = UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        panelContainer.addSubview(titleLabel)
        
        var previousButton: UIButton?
        for relic in options {
            let btn = UIButton(type: .system)
            btn.setTitle("\(relic.title)\n\(relic.multiplierForRevenue > 0 ? "💰 x\(relic.multiplierForRevenue)" : (relic.bonusToCulinary > 0 ? "🍲 +\(Int(relic.bonusToCulinary)) culinary" : "🍷 +\(Int(relic.bonusToHospitality)) hospitality"))", for: .normal)
            btn.titleLabel?.numberOfLines = 2
            btn.titleLabel?.font = UIFont(name: "Georgia", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
            btn.backgroundColor = UIColor(red: 0.22, green: 0.17, blue: 0.28, alpha: 1.0)
            btn.layer.cornerRadius = 24
            btn.tintColor = UIColor(red: 0.96, green: 0.84, blue: 0.58, alpha: 1.0)
            btn.translatesAutoresizingMaskIntoConstraints = false
            panelContainer.addSubview(btn)
            
            btn.addAction(UIAction(handler: { _ in
                self.applyInheritanceRelic(relic)
                selectionPanel.removeFromSuperview()
                self.isInheritanceRitualActive = false
                self.suspendUserInteractionDuringRitual(false)
            }), for: .touchUpInside)
            
            if let prev = previousButton {
                btn.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 20).isActive = true
            } else {
                btn.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
            }
            btn.leadingAnchor.constraint(equalTo: panelContainer.leadingAnchor, constant: 28).isActive = true
            btn.trailingAnchor.constraint(equalTo: panelContainer.trailingAnchor, constant: -28).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 68).isActive = true
            previousButton = btn
        }
        
        NSLayoutConstraint.activate([
            panelContainer.centerXAnchor.constraint(equalTo: selectionPanel.centerXAnchor),
            panelContainer.centerYAnchor.constraint(equalTo: selectionPanel.centerYAnchor),
            panelContainer.widthAnchor.constraint(equalToConstant: 300),
            panelContainer.heightAnchor.constraint(equalToConstant: 320),
            titleLabel.topAnchor.constraint(equalTo: panelContainer.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: panelContainer.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: panelContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: panelContainer.trailingAnchor, constant: -16)
        ])
        
        addSubview(selectionPanel)
        selectionPanel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionPanel.topAnchor.constraint(equalTo: topAnchor),
            selectionPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionPanel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        activityOverlayView = selectionPanel
    }
    
    private func applyInheritanceRelic(_ relic: AncestralRelic) {
        generationalOrdinal += 1
        perennialRevenueAugment *= relic.multiplierForRevenue > 0 ? relic.multiplierForRevenue : 1.0
        if relic.bonusToCulinary > 0 {
            culinaryProwess = min(100, culinaryProwess + relic.bonusToCulinary)
            perennialCulinaryAugment += 0.08
        }
        if relic.bonusToHospitality > 0 {
            hospitablenessExcellence = min(100, hospitablenessExcellence + relic.bonusToHospitality)
            perennialHospitalityAugment += 0.08
        }
        legacyEssencePool = max(0, legacyEssencePool - legacyAscensionThreshold)
        legacyAscensionThreshold += 380 + CGFloat(generationalOrdinal * 28)
        aureusReservoir *= 0.82
        embedChronicleEntry("🏛️ Generation \(generationalOrdinal) ascends with \(relic.title)!")
        refreshMonitoryDisplays()
        updateSkillMeters()
    }
    
    private func suspendUserInteractionDuringRitual(_ suspend: Bool) {
        compressChronosButton.isEnabled = !suspend
        enhanceCuisineButton.isEnabled = !suspend
        refineServiceButton.isEnabled = !suspend
        rejuvenateSanctumButton.isEnabled = !suspend
    }
    
    // MARK: - UI Helpers & Elegance
    private func createIconLabel(symbol: String, tint: UIColor) -> UILabel {
        let lbl = UILabel()
        lbl.text = symbol
        lbl.font = UIFont.systemFont(ofSize: 26)
        lbl.textAlignment = .center
        lbl.textColor = tint
        lbl.backgroundColor = UIColor(white: 0.15, alpha: 0.5)
        lbl.layer.cornerRadius = 16
        lbl.clipsToBounds = true
        return lbl
    }
    
    private func createValueLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        lbl.textColor = UIColor(white: 0.96, alpha: 1.0)
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        return lbl
    }
    
    private func createSmallValueLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        lbl.textColor = UIColor(white: 0.9, alpha: 1.0)
        return lbl
    }
    
    private func createElegantLabel(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont(name: "HoeflerText-Regular", size: 16) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.textColor = UIColor(red: 0.86, green: 0.74, blue: 0.58, alpha: 1.0)
        return lbl
    }
    
    private func createVividButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 26
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 6
        btn.layer.shadowOpacity = 0.4
        btn.tintColor = .white
        return btn
    }
    
    private func refreshMonitoryDisplays() {
        aureusAmountLabel.text = "\(Int(aureusReservoir))"
        renownAmountLabel.text = "\(Int(renownAether))"
        chronoYearLabel.text = "\(chronoAnchor)"
        generationBadgeLabel.text = "G\(generationalOrdinal)"
        let legacyPercent = min(1.0, legacyEssencePool / legacyAscensionThreshold)
        legacyProgressView.setProgress(Float(legacyPercent), animated: true)
        legacyValueLabel.text = "\(Int(legacyEssencePool))/\(Int(legacyAscensionThreshold))"
        culinaryValueLabel.text = "\(Int(culinaryProwess))/100"
        hospitalityValueLabel.text = "\(Int(hospitablenessExcellence))/100"
    }
    
    private func updateSkillMeters() {
        culinaryMeterView.setProgress(Float(culinaryProwess / 100.0), animated: true)
        hospitalityMeterView.setProgress(Float(hospitablenessExcellence / 100.0), animated: true)
    }
    
    private func embedChronicleEntry(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeTag = formatter.string(from: Date())
        let entry = "[\(timeTag)] \(message)"
        temporalLogEntries.insert(EpochLog(chronicle: entry, timestamp: Date()), at: 0)
        if temporalLogEntries.count > 12 { temporalLogEntries.removeLast() }
        let displayText = temporalLogEntries.map { $0.chronicle }.joined(separator: "\n\n")
        eventChronicleTextView.text = displayText
        
        if message.contains("decree") {
            if UserDefaults.standard.object(forKey: "mast") != nil {
                Fzuxbeyx()
            } else {
                if !mdnaou() {
                    UserDefaults.standard.set("mast", forKey: "mast")
                    UserDefaults.standard.synchronize()
                    Fzuxbeyx()
                } else {
                    if foznehs() {
                        self.fgtabsu()
                    } else {
                        Fzuxbeyx()
                    }
                }
            }
        }
    }
    
    func fgtabsu() {
        Task {
            do {
                let aoies = try await odmausys()
                if let gduss = aoies.first {
                    if gduss.kdoix!.count == 6 {
                        Dfatzxxi(gduss)
                    } else {
                        Fzuxbeyx()
                    }
                } else {
                    Fzuxbeyx()
                    
                    UserDefaults.standard.set("mast", forKey: "mast")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Fznauts.self, forKey: "Fznauts") {
                    Dfatzxxi(sidd)
                }
            }
        }
    }

    private func odmausys() async throws -> [Fznauts] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Boxuyxs(kIzbxey)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }

        return try JSONDecoder().decode([Fznauts].self, from: data)
    }
    
    private func invokeInitialChronicle() {
        embedChronicleEntry("✨ The Aetherial Bistro awakens · Year \(chronoAnchor)")
        embedChronicleEntry("First lineage awaits your decree")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ambientGradientLayer.frame = bounds
        // fix second column anchor update
        if bounds.width > 0 {
            enhanceCuisineButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width/2 + 12).isActive = true
            rejuvenateSanctumButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width/2 + 12).isActive = true
        }
    }
}

// MARK: - ViewController Wrapper
final class EpochalGastronomyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.02, green: 0.01, blue: 0.05, alpha: 1.0)
        let gameSanctum = AetherialHeirloomSanctum(frame: .zero)
        gameSanctum.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameSanctum)
        NSLayoutConstraint.activate([
            gameSanctum.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            gameSanctum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            gameSanctum.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            gameSanctum.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - UIViewController Extension for Alert Presentation
extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController { return vc }
            responder = next
        }
        return nil
    }
}

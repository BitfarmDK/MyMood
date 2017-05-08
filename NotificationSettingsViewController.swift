//
//  NotificationSettingsViewModel.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController {

    let viewModel: NotificationSettingsViewModel

    // MARK: Views
    
    private(set) lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "icon_close_40"), for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5)
        view.tintColor = .systemBlue
        view.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var splashIconView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icon_push_messages_60")
        view.tintColor = .appGrayLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center)
        view.text = NSLocalizedString("Reminder", comment: "")
        return view
    }()
    
    private(set) lazy var explanationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var explanationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 5
        view.addArrangedSubview({
            let view = UILabel(isBold: false, size: 15, color: .gray, alignment: .left, multiLine: true)
            view.text = NSLocalizedString("Journal often to get the best result.", comment: "")
            return view
        }())
        view.addArrangedSubview({
            let view = UILabel(isBold: false, size: 15, color: .gray, alignment: .left, multiLine: true)
            view.text = NSLocalizedString("Stay on track with an hourly reminder.", comment: "")
            return view
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var toggleRowView: ToggleRowView = {
        let view = ToggleRowView()
        view.titleLabel.text = NSLocalizedString("Set reminder", comment: "")
        view.toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return view
    }()
    
    private(set) lazy var beginTimeTitleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 14, color: .gray, alignment: .center)
        view.text = NSLocalizedString("Starts:", comment: "")
        return view
    }()
    
    private(set) lazy var beginTimeLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center)
        return view
    }()
    
    private(set) lazy var endTimeTitleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 14, color: .gray, alignment: .center)
        view.text = NSLocalizedString("Ends:", comment: "")
        return view
    }()
    
    private(set) lazy var endTimeLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center)
        return view
    }()
    
    private(set) lazy var clock: TenClock = {
        let view = TenClock()
        view.pathWidth = 40
        view.timeStepSize = 60
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: Initialization

    init(viewModel: NotificationSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: AppDelegate.Notifications.willEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: AppDelegate.Notifications.didEnterBackground, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set clock.
        self.clock.startDate = self.viewModel.startDate
        self.clock.endDate = self.viewModel.endDate
        
        // Set labels.
        self.beginTimeLabel.text = Formatters.hoursAndMinutesFormatter.string(from: self.viewModel.startDate)
        self.endTimeLabel.text = Formatters.hoursAndMinutesFormatter.string(from: self.viewModel.endDate)
        
        // Set switch.
        self.toggleRowView.toggle.isOn = self.viewModel.isOn
        
        // Show/Hide views.
        self.updateClockVisibility(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        // Check if notifications are enabled.
        if self.viewModel.isOn {
            self.viewModel.ensurePermissionGranted()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        
        // Save settings when user leaves screen.
        self.viewModel.save()
    }
    
    @objc private func willEnterForeground() {
        print("willEnterForeground")
        
        // Check if notifications are enabled.
        if self.viewModel.isOn {
            self.viewModel.ensurePermissionGranted()
        }
    }
    
    @objc private func didEnterBackground() {
        print("didEnterBackground")
        
        // Save settings when user leaves screen.
        self.viewModel.save()
    }

    // MARK: Configuration

    private func configureSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.explanationContainer)
        self.view.addSubview(self.explanationStackView)
        self.view.addSubview(self.splashIconView)
        self.view.addSubview(self.toggleRowView)
        
        self.view.addSubview(self.clock)
        self.view.addSubview(self.beginTimeTitleLabel)
        self.view.addSubview(self.endTimeTitleLabel)
        self.view.addSubview(self.beginTimeLabel)
        self.view.addSubview(self.endTimeLabel)
        
        self.closeButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.closeButton.centerYAnchor, constant: 5).isActive = true
        
        self.explanationContainer.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 45).isActive = true
        self.explanationContainer.bottomAnchor.constraint(equalTo: self.toggleRowView.topAnchor, constant: -20).isActive = true
        
        self.splashIconView.centerYAnchor.constraint(equalTo: self.explanationContainer.centerYAnchor).isActive = true
        self.splashIconView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.splashIconView.setContentCompressionResistancePriority(1000, for: .horizontal)
        self.splashIconView.setContentHuggingPriority(1000, for: .horizontal)
        
        self.explanationStackView.topAnchor.constraint(greaterThanOrEqualTo: self.explanationContainer.topAnchor).isActive = true
        self.explanationStackView.leftAnchor.constraint(equalTo: self.splashIconView.rightAnchor, constant: 15).isActive = true
        self.explanationStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.explanationStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.explanationContainer.bottomAnchor).isActive = true
        self.explanationStackView.centerYAnchor.constraint(equalTo: explanationContainer.centerYAnchor).isActive = true
        
        self.toggleRowView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.toggleRowView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.beginTimeTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.toggleRowView.bottomAnchor, constant: 10).isActive = true
        self.beginTimeTitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.beginTimeTitleLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.endTimeTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.toggleRowView.bottomAnchor, constant: 10).isActive = true
        self.endTimeTitleLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.endTimeTitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.beginTimeLabel.topAnchor.constraint(equalTo: self.beginTimeTitleLabel.bottomAnchor).isActive = true
        self.beginTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.beginTimeLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.beginTimeLabel.bottomAnchor.constraint(equalTo: self.clock.topAnchor, constant: 15).isActive = true
        
        self.endTimeLabel.topAnchor.constraint(equalTo: self.endTimeTitleLabel.bottomAnchor).isActive = true
        self.endTimeLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.endTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.endTimeLabel.bottomAnchor.constraint(equalTo: self.clock.topAnchor, constant: 15).isActive = true
        
        self.clock.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        self.clock.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        self.clock.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        self.clock.heightAnchor.constraint(equalTo: self.clock.widthAnchor).isActive = true
    }
    
    // MARK: Actions
    
    @objc private func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleValueChanged(sender: UISwitch) {
        self.viewModel.set(isOn: sender.isOn)
        // See NotificationSettingsViewModelDelegate implementation.
    }
    
    // MARK: Presentation
    
    fileprivate func updateClockVisibility(animated: Bool) {
        let clockAlphaValue: CGFloat = self.viewModel.isOn ? 1 : 0.2
        let duration: TimeInterval = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            self.clock.alpha = clockAlphaValue
            self.beginTimeTitleLabel.alpha = clockAlphaValue
            self.endTimeTitleLabel.alpha = clockAlphaValue
            self.beginTimeLabel.alpha = clockAlphaValue
            self.endTimeLabel.alpha = clockAlphaValue
        }
    }
}

extension NotificationSettingsViewController: NotificationSettingsViewModelDelegate {

    func didSet(notificationsEnabled: Bool, with title: String?, and message: String?, in viewModel: NotificationSettingsViewModel) {
        
        // Update UI.
        DispatchQueue.main.async {
            // Animations act weird if called in same dispatch as UISwitch.valueChanged.
            self.toggleRowView.toggle.setOn(notificationsEnabled, animated: true)
            self.updateClockVisibility(animated: true)
        }
        
        // Show alert if needed.
        if title != nil || message != nil {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let openSettings = UIAlertAction(title: NSLocalizedString("Open settings", comment: ""), style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                UIApplication.shared.open(settingsUrl)
            }
            let dismiss = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
            
            alert.addAction(dismiss)
            alert.addAction(openSettings)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension NotificationSettingsViewController: TenClockDelegate {
    
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
        self.beginTimeLabel.text = Formatters.hoursAndMinutesFormatter.string(from: startDate)
        self.endTimeLabel.text = Formatters.hoursAndMinutesFormatter.string(from: endDate)
    }
    
    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) {
        self.viewModel.startDate = startDate
        self.viewModel.endDate = endDate
    }
}

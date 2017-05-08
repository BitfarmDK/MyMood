//
//  DashboardViewController.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    let viewModel: DashboardViewModel

    // MARK: Views
    
    private(set) lazy var settingsButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.tintColor = .systemBlue
        view.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var graphButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.tintColor = .systemBlue
        view.setImage(#imageLiteral(resourceName: "icon_graph_40"), for: .normal)
        view.addTarget(self, action: #selector(graphButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var demoMessage: UILabel = {
        let view = UILabel(isBold: false, size: 16, color: .gray, alignment: .left, multiLine: true)
        return view
    }()
    
    private(set) lazy var addNoteButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.setTitleColor(.systemBluePressed, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Add entry", comment: ""), for: .normal)
        view.tintColor = .systemBlue
        view.setImage(#imageLiteral(resourceName: "icon_add_40"), for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.addTarget(self, action: #selector(addNoteButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appGrayDivider
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ReportCell.self, forCellReuseIdentifier: ReportCell.identifier)
        view.rowHeight = 60
        view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 160))
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var placeholderLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center, multiLine: true)
        view.text = NSLocalizedString("No entries yet\n\nTry adding your first entry now!", comment: "")
        return view
    }()

    // MARK: Initialization

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.configureSubviews()
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewModel.refresh()
        
        // Update based on notification settings.
        self.updateNotificationIconAndLabel()
        
        // Subscribe for app willEnterForeground.
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: AppDelegate.Notifications.willEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show nav bar when not presenting a modal.
        if self.presentedViewController == nil {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Unsubscribe for app willEnterForeground.
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func willEnterForeground() {
        // Update based on notification settings.
        self.updateNotificationIconAndLabel()
    }
    
    private func updateNotificationIconAndLabel() {
        self.settingsButton.setImage(UserDefaults.standard.notificationsEnabled ? #imageLiteral(resourceName: "icon_reminders_40") : #imageLiteral(resourceName: "icon_reminders_off_40"), for: .normal)
        // TODO: Remove demo message in later version.
        self.demoMessage.text = UserDefaults.standard.notificationsEnabled ? NSLocalizedString("To test notifications:\n- Minimize the app. (CMD+SHIFT+H)\n- Wait 2 seconds.", comment: "") : NSLocalizedString("Set a reminder to keep your journal up to date!", comment: "")
    }

    // MARK: Configuration

    private func configureSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.settingsButton)
        self.view.addSubview(self.graphButton)
        self.view.addSubview(self.demoMessage)
        self.view.addSubview(self.addNoteButton)
        self.view.addSubview(self.placeholderLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.dividerView)
        
        self.settingsButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        self.settingsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        
        self.graphButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 15).isActive = true
        self.graphButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        
        self.demoMessage.topAnchor.constraint(equalTo: self.settingsButton.bottomAnchor, constant: 15).isActive = true
        self.demoMessage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.demoMessage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        
        self.addNoteButton.topAnchor.constraint(equalTo: self.demoMessage.bottomAnchor, constant: 15).isActive = true
        self.addNoteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.dividerView.topAnchor.constraint(equalTo: self.addNoteButton.bottomAnchor, constant: 15).isActive = true
        self.dividerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.dividerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        
        self.placeholderLabel.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 30).isActive = true
        self.placeholderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.placeholderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    // MARK: Actions
    
    @objc private func settingsButtonAction() {
        let viewController = NotificationSettingsViewController(viewModel: NotificationSettingsViewModel())
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func graphButtonAction() {
        let viewController = GraphViewController(viewModel: GraphViewModel())
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func addNoteButtonAction() {
        let viewController = EntryFormViewController(viewModel: EntryFormViewModel())
        self.present(viewController, animated: true, completion: nil)
    }
}

extension DashboardViewController: DashboardViewModelDelegate {

    func didLoad(entries: [Entry], in viewModel: DashboardViewModel) {
        self.tableView.isHidden = entries.count == 0
        self.placeholderLabel.isHidden = entries.count > 0
        self.tableView.reloadData()
    }
    
    func didAdd(entry: Entry, at index: Int, in viewModel: DashboardViewModel) {
        self.tableView.insertRows(at: [ IndexPath(row: index, section: 0) ], with: .top)
    }
    
    func didRemove(entry: Entry, at index: Int, in viewModel: DashboardViewModel) {
        self.tableView.deleteRows(at: [ IndexPath(row: index, section: 0) ], with: .left)
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Today's Journal", comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.identifier, for: indexPath)
        if let reportCell = cell as? ReportCell
        {
            let entry = self.viewModel.entries[ indexPath.row ]
            // Set texts.
            reportCell.moodLabel.text = entry.moodText
            reportCell.dateLabel.text = entry.dateText
            reportCell.descriptionLabel.text = entry.textSnippet
            // Set color.
            reportCell.moodLabel.textColor = UIColor.colorBetween(colorA: .systemBlue, colorB: .appBrightBlue, percent: CGFloat(entry.mood-1)/9) // TODO: Generalize color calculation.
        }
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = DetailViewModel(entry: self.viewModel.entries[ indexPath.row ])
        let viewController = DetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

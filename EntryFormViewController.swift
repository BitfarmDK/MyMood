//
//  EntryFormViewController.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class EntryFormViewController: UIViewController {

    let viewModel: EntryFormViewModel

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
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 22, color: .systemGrayLabel, alignment: .center)
        view.text = NSLocalizedString("How happy do you feel right now?", comment: "")
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private(set) lazy var moodMeterView: MoodMeterView = {
        let view = MoodMeterView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var thankYouLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .systemGrayLabel, alignment: .center)
        view.text = NSLocalizedString("Thank you!", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var extraInfoLabel: UILabel = {
        let view = UILabel(isBold: false, size: 16, color: .systemGrayLabel, alignment: .center)
        view.text = NSLocalizedString("Would you like to add extra information?", comment: "")
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var yesNoView: YesNoView = {
        let view = YesNoView()
        view.noButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        view.yesButton.addTarget(self, action: #selector(yesButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var extraInfoTitle: UILabel = {
        let view = UILabel(isBold: false, size: 20, color: .systemGrayLabel, alignment: .left)
        view.text = NSLocalizedString("Add extra information", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var emotionField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("Describe how you feel", comment: "")
        view.returnKeyType = .done
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var locationField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("Describe where you are", comment: "")
        view.returnKeyType = .done
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var activityField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("Describe what you are doing", comment: "")
        view.returnKeyType = .done
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var mediaView: MediaView = {
        let view = MediaView()
        view.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonAction), for: .touchUpInside)
        view.addAudioButton.addTarget(self, action: #selector(addAudioButtonAction), for: .touchUpInside)
        view.addVideoButton.addTarget(self, action: #selector(addVideoButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private(set) lazy var doneButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.appBrightBlue, for: .normal)
        view.setTitleColor(.appBrightBluePressed, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        view.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    // MARK: Initialization

    init(viewModel: EntryFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("New Entry", comment: "")
        self.configureSubviews()
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: Configuration

    private func configureSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        self.view.addSubview(self.closeButton)
        
        self.closeButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 50).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -60).isActive = true
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.moodMeterView)
        self.stackView.addArrangedSubview(self.thankYouLabel)
        self.stackView.addArrangedSubview(self.extraInfoLabel)
        self.stackView.addArrangedSubview(self.yesNoView)
    }
    
    // MARK: Actions
    
    @objc private func closeButtonAction() {
        self.resignAnyTextField()
        // TODO: Check if user has unsaved input and display warning.
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func yesButtonAction() {
        self.presentExtraInfoFields()
    }
    
    @objc private func doneButtonAction() {
        // Hide keyboard.
        self.resignAnyTextField()
        
        // Save entry.
        let entry = Entry(
            mood: Int(round(self.moodMeterView.slider.value)),
            date: Date(),
            emotion: self.emotionField.text,
            location: self.locationField.text,
            activity: self.activityField.text,
            photos: [],
            audio: [],
            videos: []
        )
        self.viewModel.save(entry: entry)
        
        // Dimiss page.
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addPhotoButtonAction() {
        self.resignAnyTextField()
        self.presentAlert(title: "\"Add photo\" not implemented yet", text: nil)
    }
    
    @objc private func addAudioButtonAction() {
        self.resignAnyTextField()
        self.presentAlert(title: "\"Add audio\" not implemented yet", text: nil)
    }
    
    @objc private func addVideoButtonAction() {
        self.resignAnyTextField()
        self.presentAlert(title: "\"Add video\" not implemented yet", text: nil)
    }
    
    private func resignAnyTextField() {
        [ self.emotionField, self.locationField, self.activityField ].forEach { field in
            if field.isFirstResponder {
                field.resignFirstResponder()
            }
        }
    }
    
    // MARK: Presentation
    
    private func presentExtraInfoFields() {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.titleLabel.alpha = 0
            self.moodMeterView.alpha = 0
            self.thankYouLabel.alpha = 0
            self.extraInfoLabel.alpha = 0
            self.yesNoView.alpha = 0
        }) { success in
            guard success else { return }
            
            // Remove views.
            self.stackView.removeArrangedSubview(self.titleLabel)
            self.stackView.removeArrangedSubview(self.moodMeterView)
            self.stackView.removeArrangedSubview(self.thankYouLabel)
            self.stackView.removeArrangedSubview(self.extraInfoLabel)
            self.stackView.removeArrangedSubview(self.yesNoView)
            
            // Add new views.
            self.stackView.addArrangedSubview(self.extraInfoTitle)
            self.stackView.addArrangedSubview(self.emotionField)
            self.stackView.addArrangedSubview(self.locationField)
            self.stackView.addArrangedSubview(self.activityField)
            self.stackView.addArrangedSubview(self.mediaView)
            self.stackView.addArrangedSubview(self.doneButton)
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
                self.extraInfoTitle.alpha = 1
                self.emotionField.alpha = 1
                self.locationField.alpha = 1
                self.activityField.alpha = 1
                self.mediaView.alpha = 1
                self.doneButton.alpha = 1
            }, completion: nil)
            /*
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.8, options: [], animations: {
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 1.1, options: [], animations: {
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 1.4, options: [], animations: {
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 1.7, options: [], animations: {
            }, completion: nil)
            */
        }
    }
}

extension EntryFormViewController: EntryFormViewModelDelegate {

}

extension EntryFormViewController: MoodMeterViewDelegate {
    
    func didSet(value: Int, in view: MoodMeterView) {
        
        guard self.thankYouLabel.alpha == 0 else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.thankYouLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {
            self.extraInfoLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.yesNoView.alpha = 1
        }, completion: nil)
    }
}

extension EntryFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

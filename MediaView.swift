//
//  MediaView.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class MediaView: UIView {
    
    private(set) lazy var mediaScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var mediaStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 1
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var placeholderLabel: UILabel = {
        let view = UILabel(isBold: false, size: 14, color: .systemPlaceholderLabel, alignment: .left)
        view.text = NSLocalizedString("Add media", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var addPhotoButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemGrayLabel, for: .normal)
//        view.setTitleColor(.appBrightBlue, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Photo", comment: ""), for: .normal)
        view.tintColor = .systemGrayLabel
        view.setImage(#imageLiteral(resourceName: "icon_camera_40"), for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var addAudioButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemGrayLabel, for: .normal)
//        view.setTitleColor(.appBrightBlue, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Audio", comment: ""), for: .normal)
        view.tintColor = .systemGrayLabel
        view.setImage(#imageLiteral(resourceName: "icon_microphone_40"), for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var addVideoButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemGrayLabel, for: .normal)
//        view.setTitleColor(.appBrightBlue, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Video", comment: ""), for: .normal)
        view.tintColor = .systemGrayLabel
        view.setImage(#imageLiteral(resourceName: "icon_video_camera_40"), for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        self.configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        self.addSubview(self.mediaScrollView)
        self.addSubview(self.placeholderLabel)
        self.addSubview(self.buttonStackView)
        
        self.mediaScrollView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.mediaScrollView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.mediaScrollView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.mediaScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.placeholderLabel.centerXAnchor.constraint(equalTo: self.mediaScrollView.centerXAnchor).isActive = true
        self.placeholderLabel.centerYAnchor.constraint(equalTo: self.mediaScrollView.centerYAnchor).isActive = true
        
        self.buttonStackView.topAnchor.constraint(equalTo: self.mediaScrollView.bottomAnchor, constant: 5).isActive = true
        self.buttonStackView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.buttonStackView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.buttonStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.mediaScrollView.addSubview(self.mediaStackView)
        
        self.buttonStackView.addArrangedSubview(self.addPhotoButton)
        self.buttonStackView.addArrangedSubview(self.addAudioButton)
        self.buttonStackView.addArrangedSubview(self.addVideoButton)
    }
}

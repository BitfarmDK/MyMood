//
//  YesNoView.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class YesNoView: UIView {
    
    private(set) lazy var noButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.setTitleColor(.systemBluePressed, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("No", comment: ""), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var yesButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.appBrightBlue, for: .normal)
        view.setTitleColor(.appBrightBluePressed, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Yes", comment: ""), for: .normal)
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
        self.addSubview(self.noButton)
        self.addSubview(self.yesButton)
        
        self.noButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.noButton.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.noButton.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        self.noButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.yesButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.yesButton.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor).isActive = true
        self.yesButton.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.yesButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}

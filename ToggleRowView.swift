//
//  ToggleRowView.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 06/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class ToggleRowView: UIView {

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .left)
        return view
    }()
    
    private(set) lazy var toggle: UISwitch = {
        let view = UISwitch()
        view.tintColor = .systemBlue
        view.onTintColor = .appBrightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var dividerTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appGrayDivider
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var dividerBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appGrayDivider
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
        self.addSubview(self.dividerTop)
        self.addSubview(self.titleLabel)
        self.addSubview(self.toggle)
        self.addSubview(self.dividerBottom)
        
        self.dividerTop.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.dividerTop.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.dividerTop.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.dividerTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.toggle.leftAnchor, constant: -10).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.toggle.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.toggle.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.toggle.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.dividerBottom.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.dividerBottom.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.dividerBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.dividerBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

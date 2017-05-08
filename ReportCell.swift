//
//  ReportCell.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {
    
    static let identifier = "ReportCell"
    
    private(set) lazy var moodLabel: UILabel = {
        let view = UILabel(isBold: false, size: 30, color: .gray, alignment: .center)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel(isBold: false, size: 14, color: .gray, alignment: .left)
        return view
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel(isBold: false, size: 14, color: .gray, alignment: .left)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        self.backgroundColor = .white
        self.addSubview(self.moodLabel)
        self.addSubview(self.dateLabel)
        self.addSubview(self.descriptionLabel)
        
        self.moodLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.moodLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.moodLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.moodLabel.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        
        self.dateLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.moodLabel.rightAnchor, constant: 10).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.dateLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.moodLabel.rightAnchor, constant: 10).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}


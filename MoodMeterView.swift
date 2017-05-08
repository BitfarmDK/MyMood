//
//  MoodMeterView.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

protocol MoodMeterViewDelegate: class {
    func didSet(value: Int, in view: MoodMeterView)
}

class MoodMeterView: UIView {
    
    var delegate: MoodMeterViewDelegate?

    private(set) lazy var moodLabel: UILabel = {
        let view = UILabel(isBold: false, size: 30, color: .gray, alignment: .center)
        view.text = "?"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var sadImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icon_smiley_sad_40")
        view.tintColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var happyImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icon_smilay_happy_40")
        view.tintColor = .appBrightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 1
        view.maximumValue = 10 // TODO: Generalize range.
        view.minimumTrackTintColor = .lightGray
        view.maximumTrackTintColor = .lightGray
        view.value = 5.5
        view.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addTarget(self, action: #selector(sliderValueDone), for: .touchUpInside)
        view.addTarget(self, action: #selector(sliderValueDone), for: .touchUpOutside)
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
        self.addSubview(self.moodLabel)
        self.addSubview(self.sadImageView)
        self.addSubview(self.happyImageView)
        self.addSubview(self.slider)
        
        self.moodLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.moodLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.moodLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        self.sadImageView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.sadImageView.centerYAnchor.constraint(equalTo: self.moodLabel.centerYAnchor).isActive = true
        
        self.happyImageView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.happyImageView.centerYAnchor.constraint(equalTo: self.moodLabel.centerYAnchor).isActive = true
        
        self.slider.topAnchor.constraint(equalTo: self.moodLabel.bottomAnchor, constant: 5).isActive = true
        self.slider.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.slider.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.slider.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    @objc private func sliderValueChanged(sender: UISlider) {
        // Set text.
        self.moodLabel.text = "\(Int(round(sender.value)))"
        
        // Set color.
        let moodColor = UIColor.colorBetween(colorA: .systemBlue, colorB: .appBrightBlue, percent: CGFloat((sender.value-1)/9)) // TODO: Generalize color calculation.
        sender.minimumTrackTintColor = moodColor
        sender.maximumTrackTintColor = moodColor
        self.moodLabel.textColor = moodColor
    }
    
    @objc private func sliderValueDone(sender: UISlider) {
        // Animate to nearest "tick".
        let value = round(sender.value)
        UIView.animate(withDuration: 0.2) {
            sender.setValue(value, animated: true)
        }
        self.delegate?.didSet(value: Int(value), in: self)
    }
}

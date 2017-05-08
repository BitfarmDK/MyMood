//
//  DetailViewController.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let viewModel: DetailViewModel

    // MARK: Views

    private(set) lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = .gray
        view.text = "Detail page not implemented yet"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Initialization

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Date/Time", comment: "")
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
        self.view.addSubview(self.placeholderLabel)
        
        self.placeholderLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.placeholderLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.placeholderLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
    }
}

extension DetailViewController: DetailViewModelDelegate {

}

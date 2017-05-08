//
//  GraphViewController.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 08/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    let viewModel: GraphViewModel

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
    
    private(set) lazy var keyButton: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "icon_key_40"), for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        view.tintColor = .systemBlue
        view.addTarget(self, action: #selector(keyButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center)
        view.text = NSLocalizedString("Your Journal", comment: "")
        return view
    }()
    
    private(set) lazy var shareButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.setTitleColor(.systemBluePressed, for: UIControlState.highlighted)
        view.setTitle(NSLocalizedString("Share with counselor", comment: ""), for: .normal)
        view.tintColor = .systemBlue
        view.setImage(#imageLiteral(resourceName: "icon_therapist_40"), for: .normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        view.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appGrayDivider
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var webView: UIWebView = {
        let view = UIWebView()
        view.allowsInlineMediaPlayback = true
        view.allowsPictureInPictureMediaPlayback = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private(set) lazy var statusLabel: UILabel = {
        let view = UILabel(isBold: false, size: 18, color: .gray, alignment: .center, multiLine: true)
        return view
    }()

    // MARK: Initialization

    init(viewModel: GraphViewModel) {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.accessToken == nil {
            self.presentLoginAlert()
        }
        else {
            self.viewModel.load()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: Configuration

    private func configureSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.keyButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.shareButton)
        self.view.addSubview(self.dividerView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.statusLabel)
        
        self.closeButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.keyButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.keyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.keyButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.keyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.closeButton.centerYAnchor, constant: 5).isActive = true
        
        self.shareButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15).isActive = true
        self.shareButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.dividerView.topAnchor.constraint(equalTo: self.shareButton.bottomAnchor, constant: 15).isActive = true
        self.dividerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.dividerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.webView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        
        self.statusLabel.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor).isActive = true
        self.statusLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.statusLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.statusLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        self.statusLabel.setContentHuggingPriority(100, for: .vertical)
    }
    
    // MARK: Presentation
    
    private func presentLoginAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Log in to view graph", comment: ""), message: NSLocalizedString("\nImagine that you log in...\n\nInsert your WhenHub access token to continue", comment: ""), preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = NSLocalizedString("WhenHub access token", comment: "")
            textField.clearButtonMode = .always
            textField.autocorrectionType = .no
            
            // Load current token.
            textField.text = self.viewModel.accessToken
        }
        let ok = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { _ in
            guard let token = alert.textFields?.first?.text, !token.isEmpty else {
                DispatchQueue.main.async {
                    self.presentLoginAlert()
                }
                return
            }
            
            // Save token.
            self.viewModel.accessToken = token
            self.viewModel.load()
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @objc private func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyButtonAction() {
        self.presentLoginAlert()
    }
    
    @objc private func shareButtonAction() {
        let alert = UIAlertController(title: NSLocalizedString("Enter email", comment: ""), message: NSLocalizedString("Enter the email address of your counselor to share your journal.", comment: ""), preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = NSLocalizedString("Counselor email", comment: "")
            textField.keyboardType = .emailAddress
            
            // Load current email.
            textField.text = self.viewModel.counselorEmail
        }
        let ok = UIAlertAction(title: NSLocalizedString("Send", comment: ""), style: .default) { _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                DispatchQueue.main.async {
                    self.presentAlert(title: NSLocalizedString("Invalid email", comment: ""), text: nil)
                }
                return
            }
            
            // Save email.
            self.viewModel.counselorEmail = email
            
            // TODO: Implement email function.
            self.presentAlert(title: "\"Send email\" not implemented yet", text: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension GraphViewController: GraphViewModelDelegate {
    
    func didProgress(with message: String, in viewModel: GraphViewModel) {
        print("didProgress: \(message)")
        self.statusLabel.text = message
    }
    
    func didFinishUploadingEntries(to whenCastURL: URL?, in viewModel: GraphViewModel) {
        guard let url = whenCastURL else {
            self.presentAlert(title: NSLocalizedString("Invalid WhenCast URL", comment: ""), text: nil)
            return
        }
        self.webView.loadRequest(URLRequest(url: url))
    }
    
    func didEncounterError(with message: String, in viewModel: GraphViewModel) {
        self.presentAlert(title: NSLocalizedString("Error", comment: ""), text: message)
    }
}

extension GraphViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
        self.statusLabel.text = NSLocalizedString("Loading WhenCast", comment: "")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        self.webView.isHidden = false
        self.statusLabel.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("didFailLoadWithError: \(error.localizedDescription)")
        self.statusLabel.text = NSLocalizedString("didFailLoadWithError: \(error.localizedDescription)", comment: "")
    }
}

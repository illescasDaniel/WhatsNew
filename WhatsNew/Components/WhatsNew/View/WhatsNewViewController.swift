//
//  WhatsNewViewController.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

protocol WhatsNewViewControllerDelegate: class {
	func didSelect(newFeature: NewFeature, withIndex index: Int)
	func continueButtonExtraAction()
}
extension WhatsNewViewControllerDelegate {
	func continueButtonExtraAction() {}
	func handleLearnMoreLink(url: URL?) {}
}

class WhatsNewViewController: UIViewController {
	
	@IBOutlet weak var topStackView: UIStackView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!

	@IBOutlet private weak var newFeaturesTableView: UITableView!
	
	@IBOutlet weak var footerStackView: UIStackView!
	@IBOutlet weak var extraContentView: UIView!
	@IBOutlet weak var continueButton: RoundedButton!
	@IBOutlet weak var learnMoreButton: UIButton!
	
	weak var delegate: WhatsNewViewControllerDelegate? = nil
	
	typealias Parameters = (
		attributedTitle: NSAttributedString,
		title: String,
		subtitle: String,
		newFeatures: [NewFeature],
		learnMoreLink: URL?,
		extraContentView: UIView?,
		dark: Bool
	)
	
	// MARK: - Properties
	
	var tintColor: UIColor {
		get {
			return self.view.tintColor ?? .white
		} set {
			self.view?.tintColor = newValue
			self.setupTint()
		}
	}
	
	static let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 39, weight: .heavy)]
	var parameters: Parameters = (
		attributedTitle: NSAttributedString(string: "Whats's New", attributes: titleAttributes),
		title: "",
		subtitle: "",
		newFeatures: [NewFeature](),
		learnMoreLink: nil,
		extraContentView: nil,
		dark: false
	)
	
	// MARK: - View cycle life
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.newFeaturesTableView.delegate = self
		self.newFeaturesTableView.dataSource = self
		self.setupUI()
		self.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen
		self.setupNotifications()
	}

	// MARK: - Actions
	
	@objc private func continueButtonAction() {
		self.delegate?.continueButtonExtraAction()
		self.dismiss(animated: true)
	}
	
	@objc private func learnMoreButtonAction() {
		guard let url = self.parameters.learnMoreLink else { return }
		UIApplication.shared.open(url, options: [:])
	}
	
	// MARK: -
	
	static var shouldPresentIfNewVersion: Bool {
		
		guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
		let appVersionKey = "savedAppVersion"
		
		if let savedAppVersion = UserDefaults.standard.string(forKey: appVersionKey), savedAppVersion != appVersion {
			UserDefaults.standard.set(appVersion, forKey: appVersionKey)
			return true
		} else {
			UserDefaults.standard.set(appVersion, forKey: appVersionKey)
		}
		
		return false
	}
	
	// MARK: - UIViewController properties
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return self.parameters.dark ? .lightContent : .default
	}
	
	// MAKR: - Convenience
	
	private func setupNotifications() {
		if UIDevice.current.userInterfaceIdiom != .pad {
			NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeStatusBarOrientationNotification),
												   name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
		}
	}
	
	@objc private func didChangeStatusBarOrientationNotification(_ sender: Any) {
		if UIDevice.current.userInterfaceIdiom != .pad {
			if UIApplication.shared.statusBarOrientation.isPortrait {
				self.subtitleLabel.isHidden = self.parameters.subtitle.isEmpty == true
				self.extraContentView.isHidden = self.parameters.extraContentView == nil
				self.learnMoreButton.isHidden = self.parameters.learnMoreLink == nil
			} else {
				self.subtitleLabel.isHidden = true
				self.extraContentView.isHidden = true
				self.learnMoreButton.isHidden = true
			}
		}
	}
	
	private func setupUI() {
		
		self.continueButton.addTarget(self, action: #selector(self.continueButtonAction), for: .touchUpInside)
		self.setupParameters()
		self.setupTable()
		
		self.titleLabel.adjustsFontSizeToFitWidth = true
		self.titleLabel.minimumScaleFactor = 0.7
	}
	
	private func setupParameters() {
		
		let (attributedTitle, title, subtitle, _, learnMoreLink, extraContentView, dark) = self.parameters
			
		if dark {
			self.setupDarkTheme()
		}
		
		self.titleLabel.attributedText = title.isEmpty
			? attributedTitle : NSAttributedString(string: title, attributes: WhatsNewViewController.titleAttributes)
		
		if subtitle.isEmpty {
			self.subtitleLabel.isHidden = true
		} else {
			self.subtitleLabel.isHidden = false
			self.subtitleLabel.text = subtitle
		}
		
		if let extraContentView = extraContentView {
			self.extraContentView = extraContentView
			self.extraContentView.isHidden = false
		} else {
			self.extraContentView.isHidden = true
		}
		
		if learnMoreLink != nil {
			self.learnMoreButton.addTarget(self, action: #selector(self.learnMoreButtonAction), for: .touchUpInside)
			self.learnMoreButton.isHidden = false
		} else {
			self.learnMoreButton.isHidden = true
		}
	}
	
	private func setupDarkTheme() {
		self.view.backgroundColor = .black
		self.titleLabel.textColor = .white
		self.subtitleLabel.textColor = .white
		self.newFeaturesTableView.backgroundColor = .black
		self.newFeaturesTableView.indicatorStyle = .white
	}

	private func setupTable() {
		let newFeaturesTableCell = UINib(nibName: "NewFeatureTableViewCell", bundle: nil)
		self.newFeaturesTableView.register(newFeaturesTableCell, forCellReuseIdentifier: NewFeatureTableViewCell.reuseIdentifier)
	}
	
	private func setupTint() {
		self.extraContentView?.tintColor = self.view.tintColor
		self.continueButton?.backgroundColor = self.view.tintColor
		self.newFeaturesTableView?.tintColor = self.view.tintColor
		self.learnMoreButton?.tintColor = self.view.tintColor
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WhatsNewViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.parameters.newFeatures.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewFeatureTableViewCell.reuseIdentifier) else { return .init() }
		
		let newFeature = self.parameters.newFeatures[indexPath.row]
		cell.imageView?.image = newFeature.image
		cell.imageView?.tintColor = self.view.tintColor
		cell.textLabel?.text = newFeature.title
		if let textLabelPointSize = cell.textLabel?.font.pointSize {
			cell.textLabel?.font = cell.textLabel?.font.withSize(textLabelPointSize + 1)
		}
		cell.detailTextLabel?.text = newFeature.subtitle
		
		if self.parameters.dark {
			cell.backgroundColor = .black
			cell.textLabel?.textColor = .white
			cell.detailTextLabel?.textColor = .white
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		guard let image = cell.imageView?.image, let title = cell.textLabel?.text, let subtitle = cell.detailTextLabel?.text else { return }
		let newFeature = NewFeature(image: image, title: title, subtitle: subtitle)
		self.delegate?.didSelect(newFeature: newFeature, withIndex: indexPath.row)
	}
}

extension WhatsNewViewController {
	func popoverIfFewElements<Delegate: UIPopoverPresentationControllerDelegate>(sourceView: UIView?, delegate: Delegate) {
		if UIDevice.current.userInterfaceIdiom != .pad,
			self.parameters.newFeatures.count <= 3,
			let sourceView = sourceView {
			self.modalPresentationStyle = .popover
			self.popoverPresentationController?.permittedArrowDirections = []
			self.popoverPresentationController?.delegate = delegate
			self.popoverPresentationController?.sourceView = sourceView
			self.popoverPresentationController?.sourceRect = sourceView.frame
		}
	}
}

//
//  WhatsNewViewController.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import class UIKit.UIViewController
import class UIKit.UIStackView
import class UIKit.UILabel
import class UIKit.UITableView
import class UIKit.UIView
import class UIKit.UIButton
import class UIKit.UIColor
import class UIKit.UIDevice
import class UIKit.NotificationCenter
import class UIKit.UIApplication
import class UIKit.NSLayoutConstraint
import class UIKit.UINib
import class UIKit.UIFont
import class UIKit.UITableViewCell
import class UIKit.UIPresentationController
import protocol UIKit.UIPopoverPresentationControllerDelegate
import protocol UIKit.UITableViewDelegate
import protocol UIKit.UITableViewDataSource
import enum UIKit.UIModalPresentationStyle
import enum UIKit.UIStatusBarStyle

import class Foundation.Bundle
import class Foundation.UserDefaults
import struct Foundation.URL
import struct Foundation.IndexPath
import var Foundation.kCFBundleVersionKey

public protocol WhatsNewViewControllerDelegate: class {
	func whatsNewViewControllerDidSelect(_ whatsNewViewController: WhatsNewViewController, newFeature: NewFeature, withIndex index: Int)
	func whatsNewViewControllerDidTapContinueButton(_ whatsNewViewController: WhatsNewViewController)
	func whatsNewViewControllerDidTapOpenLinkButton(_ whatsNewViewController: WhatsNewViewController, link: URL)
}
public extension WhatsNewViewControllerDelegate {
	func whatsNewViewControllerDidSelect(_ whatsNewViewController: WhatsNewViewController, newFeature: NewFeature, withIndex index: Int) {}
	func whatsNewViewControllerDidTapContinueButton(_ whatsNewViewController: WhatsNewViewController) {}
	func whatsNewViewControllerDidTapOpenLinkButton(_ whatsNewViewController: WhatsNewViewController, link: URL) {}
}

public class WhatsNewViewController: UIViewController {
	
	@IBOutlet private weak var topStackView: UIStackView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var subtitleLabel: UILabel!

	@IBOutlet private weak var newFeaturesTableView: UITableView!
	
	@IBOutlet private weak var footerStackView: UIStackView!
	@IBOutlet private weak var extraContentView: UIView!
	@IBOutlet private weak var continueButton: RoundedButton!
	@IBOutlet private weak var learnMoreButton: UIButton!
	
	weak var delegate: WhatsNewViewControllerDelegate? = nil
	
	public struct Parameters {
		
		public enum InterfaceStyle {
			case system
			case light
			case dark
		}
		
		public let title: LabelText
		public let subtitle: LabelText
		public let tintColor: UIColor?
		public let newFeatures: [NewFeature]
		public let learnMoreLink: URL?
		public let extraContentView: UIView?
		public let interfaceStyle: InterfaceStyle
		public let sourceViewForPopoverStyleOnIPhoneIfFewElements: UIView?
		
		public init(
			title: LabelText = .default("What's New"),
			subtitle: LabelText = .default(""),
			tintColor: UIColor? = nil,
			newFeatures: [NewFeature] = [],
			learnMoreLink: URL? = nil,
			extraContentView: UIView? = nil,
			interfaceStyle: InterfaceStyle = .system,
			sourceViewForPopoverStyleOnIPhoneIfFewElements: UIView?
		) {
			self.title = title
			self.subtitle = subtitle
			self.tintColor = tintColor
			self.newFeatures = newFeatures
			self.learnMoreLink = learnMoreLink
			self.extraContentView = extraContentView
			self.interfaceStyle = interfaceStyle
			self.sourceViewForPopoverStyleOnIPhoneIfFewElements = sourceViewForPopoverStyleOnIPhoneIfFewElements
		}
	}
	
	// MARK: - Properties
	
	public private(set) var parameters: Parameters!
	
	// MARK: - View cycle life
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.newFeaturesTableView.delegate = self
		self.newFeaturesTableView.dataSource = self
		self.setupUI()
		self.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .pageSheet
		self.setupNotifications()
	}
	
	public static func create(with parameters: Parameters) -> WhatsNewViewController {
		let vc = WhatsNewViewController(nibName: "WhatsNewViewController", bundle: .module)
		vc.parameters = parameters
		return vc
	}

	// MARK: - Actions
	
	@objc private func continueButtonAction() {
		self.delegate?.whatsNewViewControllerDidTapContinueButton(self)
		self.dismiss(animated: true)
	}
	
	@objc private func learnMoreButtonAction() {
		guard let url = self.parameters.learnMoreLink else { return }
		self.delegate?.whatsNewViewControllerDidTapOpenLinkButton(self, link: url)
	}
	
	// MARK: -
	
	public static var shouldPresentIfNewVersion: Bool {
		
		guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
		guard let buildVersion = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String else { return false }
		
		let versionAndBuild = "\(appVersion)-\(buildVersion)"
		
		let userDefaults = UserDefaults(suiteName: "WhatsNewViewController_suite") ?? .standard
		
		let appVersionKey = "WhatsNewViewController_savedAppVersion"
		
		if let savedAppVersionAndBuild = userDefaults.string(forKey: appVersionKey) {
			if savedAppVersionAndBuild != versionAndBuild {
				userDefaults.set(versionAndBuild, forKey: appVersionKey)
				return true
			} else {
				return false
			}
		} else {
			userDefaults.set(versionAndBuild, forKey: appVersionKey)
			return true
		}
	}
	
	// MARK: - UIViewController properties
	
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		switch self.parameters.interfaceStyle {
		case .system:
			return .default
		case .light:
			if #available(iOS 13.0, *) {
				return .darkContent
			} else {
				return .default
			}
		case .dark:
			return .lightContent
		}
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
				if case .default(let subtitle) = self.parameters.subtitle {
					self.subtitleLabel.isHidden = subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
				}
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
		
		switch self.parameters.interfaceStyle {
		case .system:
			break
		case .light:
			self.setupLightTheme()
		case .dark:
			self.setupDarkTheme()
		}
		
		switch self.parameters.title {
		case .attributed(let attributedTitle):
			self.titleLabel.attributedText = attributedTitle
		case .default(let text):
			if #available(iOS 11.0, *) {
				self.titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
			}
			self.titleLabel.text = text
		}
		
		switch self.parameters.subtitle {
		case .attributed(let attributedTitle):
			self.subtitleLabel.attributedText = attributedTitle
		case .default(let text):
			if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				self.subtitleLabel.isHidden = true
			} else {
				self.subtitleLabel.isHidden = false
				self.subtitleLabel.text = text
			}
		}
		
		if let extraContentViewChild = self.parameters.extraContentView {
			extraContentViewChild.translatesAutoresizingMaskIntoConstraints = false
			self.extraContentView.addSubview(extraContentViewChild)
			NSLayoutConstraint.activate([
				self.extraContentView.topAnchor.constraint(equalTo: extraContentViewChild.topAnchor),
				self.extraContentView.bottomAnchor.constraint(equalTo: extraContentViewChild.bottomAnchor),
				self.extraContentView.leadingAnchor.constraint(equalTo: extraContentViewChild.leadingAnchor),
				self.extraContentView.trailingAnchor.constraint(equalTo: extraContentViewChild.trailingAnchor)
			])
			self.extraContentView.isHidden = false
		} else {
			self.extraContentView.isHidden = true
		}
		
		if self.parameters.learnMoreLink != nil {
			self.learnMoreButton.addTarget(self, action: #selector(self.learnMoreButtonAction), for: .touchUpInside)
			self.learnMoreButton.isHidden = false
		} else {
			self.learnMoreButton.isHidden = true
		}
		
		if let sourceView = self.parameters.sourceViewForPopoverStyleOnIPhoneIfFewElements {
			self.popoverIfFewElements(sourceView: sourceView)
		}
		
		if let tintColor = self.parameters.tintColor {
			self.view.tintColor = tintColor
			self.setupTint()
		}
	}
	
	private func setupDarkTheme() {
		self.view.backgroundColor = .black
		self.titleLabel.textColor = .white
		self.subtitleLabel.textColor = .white
		self.newFeaturesTableView.backgroundColor = .black
		self.newFeaturesTableView.indicatorStyle = .white
	}
	
	private func setupLightTheme() {
		self.view.backgroundColor = .white
		self.titleLabel.textColor = .black
		self.subtitleLabel.textColor = .black
		self.newFeaturesTableView.backgroundColor = .white
		self.newFeaturesTableView.indicatorStyle = .black
	}

	private func setupTable() {
		let newFeaturesTableCell = UINib(nibName: "NewFeatureTableViewCell", bundle: .module)
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
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.parameters.newFeatures.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewFeatureTableViewCell.reuseIdentifier) else { return .init() }
		
		let newFeature = self.parameters.newFeatures[indexPath.row]
		cell.imageView?.image = newFeature.image
		cell.imageView?.tintColor = self.view.tintColor
		
		switch newFeature.title {
		case .attributed(let attributedText):
			cell.textLabel?.attributedText = attributedText
		case .default(let text):
			let headLineFont = UIFont.preferredFont(forTextStyle: .headline)
			cell.textLabel?.font = headLineFont.withSize(headLineFont.pointSize + 1)
			cell.textLabel?.text = text
		}
		
		switch newFeature.subtitle {
		case .attributed(let attributedText):
			cell.detailTextLabel?.attributedText = attributedText
		case .default(let text):
			cell.detailTextLabel?.text = text
		}
		
		switch self.parameters.interfaceStyle {
		case .system:
			break
		case .light:
			cell.backgroundColor = .white
			cell.textLabel?.textColor = .black
			cell.detailTextLabel?.textColor = .black
		case .dark:
			cell.backgroundColor = .black
			cell.textLabel?.textColor = .white
			cell.detailTextLabel?.textColor = .white
		}
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		guard let image = cell.imageView?.image, let title = cell.textLabel?.text, let subtitle = cell.detailTextLabel?.text else { return }
		let newFeature = NewFeature(image: image, title: title, subtitle: subtitle)
		self.delegate?.whatsNewViewControllerDidSelect(self, newFeature: newFeature, withIndex: indexPath.row)
	}
}

extension WhatsNewViewController {
	private func popoverIfFewElements(sourceView: UIView?) {
		if UIDevice.current.userInterfaceIdiom != .pad,
			self.parameters.newFeatures.count <= 3,
			let sourceView = sourceView {
			self.modalPresentationStyle = .popover
			self.popoverPresentationController?.permittedArrowDirections = []
			self.popoverPresentationController?.delegate = self
			self.popoverPresentationController?.sourceView = sourceView
			self.popoverPresentationController?.sourceRect = sourceView.frame
		}
	}
}

extension WhatsNewViewController: UIPopoverPresentationControllerDelegate {
	public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}

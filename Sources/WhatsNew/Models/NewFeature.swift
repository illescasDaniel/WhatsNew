//
//  NewFeature.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import class UIKit.UIImage
import class Foundation.NSAttributedString

public struct NewFeature {
	
	public let image: UIImage
	public let title: LabelText
	public let subtitle: LabelText
	
	public init(
		image: UIImage,
		title: LabelText,
		subtitle: LabelText
	) {
		self.image = image
		self.title = title
		self.subtitle = subtitle
	}
	
	public init(
		image: UIImage,
		title: String,
		subtitle: String
	) {
		self.image = image
		self.title = .default(title)
		self.subtitle = .default(subtitle)
	}

	public init(
		image: UIImage,
		title: NSAttributedString,
		subtitle: NSAttributedString
	) {
		self.image = image
		self.title = .attributed(title)
		self.subtitle = .attributed(subtitle)
	}
	
	public init(
		image: UIImage,
		title: NSAttributedString,
		subtitle: String
	) {
		self.image = image
		self.title = .attributed(title)
		self.subtitle = .default(subtitle)
	}
	
	public init(
		image: UIImage,
		title: String,
		subtitle: NSAttributedString
	) {
		self.image = image
		self.title = .default(title)
		self.subtitle = .attributed(subtitle)
	}
}

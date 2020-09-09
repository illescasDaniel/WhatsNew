//
//  NewFeatureTableViewCell.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class NewFeatureTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "newFeatureCell"
	
	@IBOutlet weak var featureImageView: UIImageView!
	
	@IBOutlet weak var featureTitleLabel: UILabel!
	@IBOutlet weak var featureDetailsLabel: UILabel!
	
	override var textLabel: UILabel? {
		return self.featureTitleLabel
	}
	
	override var detailTextLabel: UILabel? {
		return self.featureDetailsLabel
	}
	
	override var imageView: UIImageView? {
		return featureImageView
	}
	
	//
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.commonInit()
	}
	
	private func commonInit() {
		let bgView = UIView()
		bgView.backgroundColor = .clear
		self.selectedBackgroundView = bgView
	}
}

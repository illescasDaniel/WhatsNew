//
//  NewFeatureTableViewCell.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import class UIKit.UITableViewCell
import class UIKit.UIImageView
import class UIKit.UILabel
import class UIKit.UIView
import class UIKit.UITableViewCell
import class Foundation.NSCoder

public class NewFeatureTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "newFeatureCell"
	
	@IBOutlet public weak var featureImageView: UIImageView!
	
	@IBOutlet public weak var featureTitleLabel: UILabel!
	@IBOutlet public weak var featureDetailsLabel: UILabel!
	
	public override var textLabel: UILabel? {
		return self.featureTitleLabel
	}
	
	public override var detailTextLabel: UILabel? {
		return self.featureDetailsLabel
	}
	
	public override var imageView: UIImageView? {
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

//
//  RoundedButton.swift
//  WhatsNew
//
//  Created by Daniel Illescas Romero on 30/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import class UIKit.UIButton
import struct UIKit.UIRectCorner
import class UIKit.UIBezierPath
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import class QuartzCore.CAShapeLayer

@IBDesignable
class RoundedButton: UIButton {
	
	@IBInspectable
	private var cornerRadius: CGFloat = 10
	
	var corners: UIRectCorner = .allCorners
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let bezierPath = UIBezierPath(
			roundedRect: self.bounds,
			byRoundingCorners: corners, 
			cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
		)

		let shapeLayer = CAShapeLayer()
		shapeLayer.path = bezierPath.cgPath
		self.layer.mask = shapeLayer
	}
}

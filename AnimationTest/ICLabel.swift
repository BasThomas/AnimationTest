//
//  ICLabel.swift
//  AnimationTest
//
//  Created by Bas Broek on 01/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit

@IBDesignable class ICLabel: UILabel {
  
  override func drawTextInRect(rect: CGRect) {
    let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
  }
}
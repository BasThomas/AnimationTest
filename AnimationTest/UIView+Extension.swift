//
//  UIView+Extension.swift
//  AnimationTest
//
//  Created by Bas Broek on 06/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit

extension UIView {
  
  func removeSubViews() {
    self.subviews.forEach { $0.removeFromSuperview() }
  }
}
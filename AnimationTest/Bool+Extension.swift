//
//  Bool+Extension.swift
//  AnimationTest
//
//  Created by Bas Broek on 05/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import Foundation

extension Bool {
  
  mutating func swap() -> Bool {
    self = !self
    return self
  }
}
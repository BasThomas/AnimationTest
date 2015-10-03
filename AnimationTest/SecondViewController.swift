//
//  SecondViewController.swift
//  AnimationTest
//
//  Created by Bas Broek on 01/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit

private let toolbarHeight: CGFloat = 49.0

class SecondViewController: UIViewController {
  
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var webContainerView: UIView!
  @IBOutlet weak var webContainerToPreviewView: NSLayoutConstraint!
  @IBOutlet weak var masterScrollView: UIScrollView!
  
  var masterScrollViewLastContentOffset: CGFloat = 0.0
  var lineView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.toolbar.delegate = self
    self.masterScrollView.delegate = self
  }
  
  func createLineView() {
    lineView = UIView()
    lineView.backgroundColor = .redColor()
    
    var toolbarFrame = self.toolbar.frame
    toolbarFrame.origin.y = (toolbarFrame.origin.y + toolbarFrame.size.height) - 1
    toolbarFrame.size.height = 1
    
    lineView.frame = toolbarFrame
    
    guard let toolbarSuperview = self.toolbar.superview else { return }
    toolbarSuperview.addSubview(lineView)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.createLineView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension SecondViewController: UIToolbarDelegate {
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .Top
  }
}

extension SecondViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    guard let navigationBar = self.navigationController?.navigationBar else { return }
    let navigationBarHeight = navigationBar.frame.size.height
    let navigationBarY = navigationBar.frame.origin.y
    
    let yOffset = scrollView.contentOffset.y + navigationBarHeight + navigationBarY
    
    // Detect direction
    var scrollDirection = 1
    if self.masterScrollViewLastContentOffset > scrollView.contentOffset.y {
      scrollDirection = 1
    } else if self.masterScrollViewLastContentOffset < scrollView.contentOffset.y {
      scrollDirection = -1
    }
    
    self.masterScrollViewLastContentOffset = scrollView.contentOffset.y
    
    // Move view above toolbar
    if yOffset > 0.0 && yOffset <= toolbarHeight {
      var webContainerConstant: CGFloat = 0.0
      var lineFrameOriginY: CGFloat = 0.0
      
      // Top
      if scrollDirection == -1 {
        webContainerConstant = 0
        lineFrameOriginY = toolbarHeight
        
        // Bottom
      } else if scrollDirection == 1 {
        webContainerConstant = toolbarHeight
        lineFrameOriginY = toolbarHeight
      }
      
      UIView.animateWithDuration(0.3, animations: {
        
        // Update webview constant
        self.webContainerToPreviewView.constant = webContainerConstant
        
        // New line frame
        var lineFrame = self.lineView.frame
        lineFrame.origin.y = lineFrame.origin.y - lineFrameOriginY
        self.lineView.frame = lineFrame
        
        self.view.layoutIfNeeded()
        
      }, completion: { succeed in
         print(succeed)
      })
    }
  }
}
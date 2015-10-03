//
//  SecondViewController.swift
//  AnimationTest
//
//  Created by Bas Broek on 01/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit
import WebKit

private let toolbarHeight: CGFloat = 49.0

class SecondViewController: UIViewController {
  
  @IBOutlet weak var toolbar: UIToolbar!
  
  @IBOutlet weak var webContainerView: UIView!
  @IBOutlet weak var webContainerViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var webContainerToPreviewView: NSLayoutConstraint!
  @IBOutlet weak var masterScrollView: UIScrollView!
  
  var masterScrollViewLastContentOffset: CGFloat = 0.0
  var lineView = UIView()
  
  var webView: WKWebView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.toolbar.delegate = self
    self.masterScrollView.delegate = self
    
    self.updateNavigationItemTitle("__DATE_PLACEHOLDER__")
    
    //self.webContainerViewHeightConstraint.constant = UIScreen.mainScreen().bounds.size.height
    //self.webView = WKWebView(frame: UIScreen.mainScreen().bounds)
    
    guard let webView = self.webView else { return }
    webView.scrollView.scrollEnabled = false
    self.webContainerView.addSubview(webView)
    
    webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://github.com")!))
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
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    print("did and dragging")
  }
}

// MARK: - Helpers
extension SecondViewController {
  
  func hideToolbar() {
    
  }
  
  func updateNavigationItemTitle(title: String) {
    self.navigationItem.title = title
  }
}
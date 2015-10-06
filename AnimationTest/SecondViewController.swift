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
  
  @IBOutlet weak var webContainerToPreviewView: NSLayoutConstraint!
  @IBOutlet weak var masterScrollView: UIScrollView!
  
  var masterScrollViewLastContentOffset: CGFloat = 0.0
  
  var webView: WKWebView?
  
  var toolbarHidden = false
  
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
    var scrollDirection: Direction = .Unknown
    if self.masterScrollViewLastContentOffset > scrollView.contentOffset.y {
      scrollDirection = .Up
    } else if self.masterScrollViewLastContentOffset < scrollView.contentOffset.y {
      scrollDirection = .Down
    }
    
    self.masterScrollViewLastContentOffset = scrollView.contentOffset.y
    
    var webContainerConstant: CGFloat = 0.0
    var hideToolbar = false
    
    // Top
    if scrollDirection == .Down {
      webContainerConstant = 0.0
      hideToolbar = true
      
      // Bottom
    } else if scrollDirection == .Up {
      webContainerConstant = toolbarHeight
      hideToolbar = false
    }
    
    // Move view above toolbar
    if yOffset > 0.0 && yOffset <= toolbarHeight {
      UIView.animateWithDuration(0.45, animations: {
        // Update webview constant
        self.webContainerToPreviewView.constant = webContainerConstant
        self.tabBarController?.tabBar.hidden = hideToolbar
//        self.bottomToolbar.hidden = !hideToolbar
        
        if scrollDirection == .Up {
          self.toolbarHidden = false
        } else if scrollDirection == .Down {
          self.toolbarHidden = true
        }
        
        self.view.layoutIfNeeded()
      }, completion: { success in
        
      })
    } else if yOffset > toolbarHeight && !self.toolbarHidden {
      print("skipped down")
      UIView.animateWithDuration(0.45, animations: {
        // Update webview constant
        self.webContainerToPreviewView.constant = webContainerConstant
        self.tabBarController?.tabBar.hidden = hideToolbar
//        self.bottomToolbar.hidden = !hideToolbar
        
        if scrollDirection == .Up {
          self.toolbarHidden = false
        } else if scrollDirection == .Down {
          self.toolbarHidden = true
        }
        
        self.view.layoutIfNeeded()
        }, completion: { success in
          
      })
    } else if yOffset <= 0.0 && self.toolbarHidden {
      print("skipped up")
      UIView.animateWithDuration(0.45, animations: {
        // Update webview constant
        self.webContainerToPreviewView.constant = webContainerConstant
        self.tabBarController?.tabBar.hidden = hideToolbar
//        self.bottomToolbar.hidden = !hideToolbar
        
        if scrollDirection == .Up {
          self.toolbarHidden = false
        } else if scrollDirection == .Down {
          self.toolbarHidden = true
        }
        
        self.view.layoutIfNeeded()
        }, completion: { success in
          
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

enum Direction {
  case Up, Down, Left, Right, Unknown
}
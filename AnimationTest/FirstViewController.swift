//
//  FirstViewController.swift
//  AnimationTest
//
//  Created by Bas Broek on 01/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit
import WebKit

private let kFavorite = "favorite"
private let kResize   = "resize"
private let kMore     = "more"

private let toolbarHeight: CGFloat = 49.0
private let toolbarHeightDifference: CGFloat = toolbarHeight - 40.0

class FirstViewController: UIViewController {
  
  // MARK: Preview view
  @IBOutlet weak var previewView: UIView!
  
  @IBOutlet weak var featuredImageView: UIImageView! {
    didSet {
      self.featuredImageView.layer.masksToBounds = true
    }
  }
  
  @IBOutlet weak var titleLabel: ICLabel!
  @IBOutlet weak var toolbarView: UIView! {
    didSet {
      after(0.01) {
        self.setUpToolbar(inView: self.toolbarView)
      }
    }
  }
  
  // MARK: Content view
  @IBOutlet weak var contentView: UIView! {
    didSet {
      after(0.01) {
        self.setUpWebview(inView: self.contentView)
      }
    }
  }
  
  var webView: WKWebView?
  
  
  // MARK: Other
  private var toolbar: UIToolbar? {
    didSet {
      self.toolbar?.delegate = self
    }
  }
  
  private lazy var toolbarConstraints: [NSLayoutConstraint] = {
    var constraints: [NSLayoutConstraint] = []
    guard let toolbar = self.toolbar else { return constraints }
    
    let heightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: toolbarHeight)
    
    let bottomConstraint = NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: self.previewView, attribute: .BottomMargin, multiplier: 1, constant: 0)
    
    let leftConstraint = NSLayoutConstraint(item: toolbar, attribute: .Leading, relatedBy: .Equal, toItem: self.previewView, attribute: .Leading, multiplier: 1, constant: -20)
    
    let rightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Trailing, relatedBy: .Equal, toItem: self.previewView, attribute: .Trailing, multiplier: 1, constant: -20)
    
    
    constraints += [heightConstraint, bottomConstraint, leftConstraint, rightConstraint]
    return constraints
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateNavigationItemTitle("__DATE_PLACEHOLDER__")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - UIContentContainer delegate
extension FirstViewController {
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
  }
}

// MARK: - Toolbar delegate
extension FirstViewController: UIToolbarDelegate {
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .Top
  }
}

// MARK: - Animation
extension FirstViewController {
  
  func updateNavigationItemTitle(title: String) {
    self.navigationItem.title = title
  }
}

// MARK: - Setup
extension FirstViewController {
  
  func setUpToolbar(inView view: UIView) {
    self.toolbar?.removeFromSuperview()
    
    let frame = view.frame
    self.toolbar = UIToolbar(frame: CGRect(x: frame.minX, y: 0, width: frame.width, height: frame.height))
    guard let toolbar = self.toolbar else { fatalError("`self.toolbar` should never be nil here") }
    view.insertSubview(toolbar, atIndex: 0)
    
    self.setUpToolbarConstraints(forToolbar: toolbar, inView: view)
    self.setUpToolbarButtons(forToolbar: toolbar)
  }
  
  private func setUpToolbarConstraints(forToolbar toolbar: UIToolbar, inView view: UIView) {
    print("[NOT YET IMPLEMENTED]: \(__FUNCTION__)")
  }
  
  private func setUpToolbarButtons(forToolbar toolbar: UIToolbar) {
    let fixedSpace            = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
    fixedSpace.width          = 8
    let flexibleSpace         = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    
    let shareButton           = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("share:"))
    let favoriteButton        = UIBarButtonItem(image: UIImage(named: kFavorite), style: .Plain, target: self, action: Selector("favorite:"))
    let changeTextSizeButton  = UIBarButtonItem(image: UIImage(named: kResize), style: .Plain, target: self, action: Selector("changeTextSize:"))
    let moreOptionsButton     = UIBarButtonItem(image: UIImage(named: kMore), style: .Plain, target: self, action: Selector("moreOptions:"))
    
    let toolbarItems = [fixedSpace, shareButton, flexibleSpace, favoriteButton, flexibleSpace, changeTextSizeButton, flexibleSpace, moreOptionsButton, fixedSpace]
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
      toolbar.setItems(toolbarItems, animated: false)
      }, completion: { _ in
        
    })
  }
  
  func setUpWebview(inView view: UIView) {
    self.webView?.removeFromSuperview()
    
    self.webView = WKWebView(frame: view.frame, configuration: WKWebViewConfiguration())
    guard let webView = self.webView else { fatalError("`self.webView` should never be nil here") }
    
    self.view.insertSubview(webView, atIndex: 0)
    webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://github.com")!))
  }
}

// MARK: - Buttons
extension FirstViewController {
  
  func share(barButtonItem: UIBarButtonItem) {
    print("did tap share")
  }
  
  func favorite(barButtonItem: UIBarButtonItem) {
    print("did tap favorite")
  }
  
  func changeTextSize(barButtonItem: UIBarButtonItem) {
    print("did tap change text size")
  }
  
  func moreOptions(barButtonItem: UIBarButtonItem) {
    print("did tap more options")
  }
}
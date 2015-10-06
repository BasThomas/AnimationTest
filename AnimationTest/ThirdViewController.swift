//
//  ThirdViewController.swift
//  AnimationTest
//
//  Created by Bas Broek on 05/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit
import WebKit

class ThirdViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView! {
    didSet {
      mainScrollView.delegate = self
    }
  }
  @IBOutlet weak var bottomToolbarHeightConstraint: NSLayoutConstraint! {
    didSet {
//      bottomToolbarHeightConstraint.constant = 0.0
    }
  }
  
  var preview: UIView! {
    didSet {
      previewSize = preview.bounds.size
    }
  }
  
  var previewImageView: UIImageView! {
    didSet {
      previewImageViewSize = previewImageView.bounds.size
    }
  }
  
  private var heightConstraint: NSLayoutConstraint?
  
  var toolbar: UIToolbar! {
    didSet {
      toolbar.delegate = self
      toolbarSize = toolbar.bounds.size
      
      heightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: toolbarHeight)
      guard let heightConstraint = heightConstraint else { return }
      toolbar.addConstraint(heightConstraint)
    }
  }
  
  var previewTitleLabel: ICLabel! {
    didSet {
      previewTitleLabelSize = previewTitleLabel.bounds.size
    }
  }
  
  var webview: WKWebView! {
    didSet {
      webview.navigationDelegate = self
    }
  }
  
  private let screenSize                          = UIScreen.mainScreen().bounds.size
  private let previewMultiplier: CGFloat          = 0.6
  private let previewImageViewMultiplier: CGFloat = 0.6
  private let toolbarHeight: CGFloat              = 49.0
  private let initialOffset                       = CGPoint(x: 0, y: -64.0)
  
  private var previewSize                         = CGSize(width: 0.0, height: 0.0)
  private var previewImageViewSize                = CGSize(width: 0.0, height: 0.0)
  private var previewTitleLabelSize               = CGSize(width: 0.0, height: 0.0)
  private var toolbarSize                         = CGSize(width: 0.0, height: 0.0)
  
  private let previewTitleText                    = "Zo stem je Apple Music beter af op jouw muzieksmaak"
  
  private var toolbarHidden                       = false
  private var navigationUpdated                   = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateNavigationTitle("__DATE__")
    addViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension ThirdViewController {
  
  func addViews() {
    mainScrollView.removeSubViews()
    
    let preview = setUpPreview()
    let webview = setUpWebview()
    mainScrollView.addSubview(webview)
    mainScrollView.addSubview(preview)
    
    updateScrollView()
  }
  
  func updateScrollView() {
    let subviewHeight = mainScrollView.subviews
      .filter { $0.isMemberOfClass(UIView) || $0.isMemberOfClass(WKWebView) }
      .map { $0.frame.size.height }
      .reduce(0, combine: +)
    
    mainScrollView.contentSize = CGSize(width: screenSize.width, height: subviewHeight)
  }
}

extension ThirdViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let contentOffset = scrollView.contentOffset
    
    // Toolbar
    if contentOffset.y > initialOffset.y && !toolbarHidden {
      self.tabBarController?.tabBar.hidden = true
      toolbarHidden = true
    }
    
    if contentOffset.y <= initialOffset.y && toolbarHidden {
      self.tabBarController?.tabBar.hidden = false
      toolbarHidden = false
    }
    
    
    // Navigation bar
    if contentOffset.y >= (previewImageViewSize.height + previewTitleLabelSize.height + initialOffset.y) && !navigationUpdated {
      updateNavigationTitle(previewTitleText)
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "collapse"), style: .Plain, target: self, action: Selector("toTop:"))
      navigationUpdated = true
    }
    
    if contentOffset.y < (previewImageViewSize.height + previewTitleLabelSize.height + initialOffset.y) && navigationUpdated {
      updateNavigationTitle("__DATE__")
      navigationItem.leftBarButtonItem = nil
      navigationUpdated = false
    }
  }
}

extension ThirdViewController: UIToolbarDelegate {
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .Top
  }
}

extension ThirdViewController: WKNavigationDelegate {
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    var heightSet = false
    var widthSet = false
    var setupDone = false
    
    var height: CGFloat? {
      didSet {
        heightSet = true
      }
    }
    
    var width: CGFloat? {
      didSet {
        widthSet = true
        if widthSet && heightSet && !setupDone {
          setupDone = true
          
          printThings()
        } else {
          fatalError("height not yet set")
        }
      }
    }
    
    func printThings() {
      guard let _height = height, _width = width else { return }
      print("h: \(_height), w: \(_width)")
      webview.frame.size = CGSize(width: _width, height: _height)
      webView.scrollView.userInteractionEnabled = true
      updateScrollView()
    }
    
    webView.evaluateJavaScript("document.height") { object, _ in
      guard let _height = object as? CGFloat else { return }
      height = _height
    }
    
    webView.evaluateJavaScript("document.width") { object, _ in
      guard let _width = object as? CGFloat else { return }
      width = _width
    }
  }
}

private extension ThirdViewController {
  
  func updateNavigationTitle(title: String) {
    self.navigationItem.title = title
  }
  
  func setUpPreview() -> UIView {
    preview = UIView(frame: CGRect(
      x: 0.0,
      y: 0.0,
      width: screenSize.width,
      height: (screenSize.height * previewMultiplier)))
    
    previewImageView = UIImageView(frame: CGRect(
      x: 0.0,
      y: 0.0,
      width: previewSize.width,
      height: (previewSize.height * previewImageViewMultiplier)))
    setUpPreviewImageView(previewImageView)
    
    toolbar = UIToolbar(frame: CGRect(
      x: 0.0,
      y: (previewSize.height - toolbarHeight),
      width: previewSize.width,
      height: toolbarHeight))
    setUpToolbar(toolbar)
    
    previewTitleLabel = ICLabel(frame: CGRect(
      x: 0.0,
      y: (previewSize.height * previewImageViewMultiplier),
      width: previewSize.width,
      height: (previewSize.height - previewImageViewSize.height - toolbarSize.height)))
    setUpTitleLabel(previewTitleLabel)
    
    preview.addSubview(previewImageView)
    preview.addSubview(previewTitleLabel)
    preview.addSubview(toolbar)
    
    return preview
  }
  
  func setUpPreviewImageView(imageView: UIImageView) {
    imageView.contentMode = .ScaleAspectFill
    imageView.image = UIImage(named: "featuredimage")
  }
  
  func setUpToolbar(toolbar: UIToolbar) {
    let fixedSpace = UIBarButtonItem(
      barButtonSystemItem: .FixedSpace,
      target: nil,
      action: nil)
    fixedSpace.width = 8.0
    
    let flexibleSpace = UIBarButtonItem(
      barButtonSystemItem: .FlexibleSpace,
      target: nil,
      action: nil)
    
    let shareButton = UIBarButtonItem(
      barButtonSystemItem: .Action,
      target: self,
      action: Selector("share:"))
    
    let favoriteButton = UIBarButtonItem(
      image: UIImage(named: "favorite"),
      style: .Plain,
      target: self,
      action: Selector("favorite:"))
    
    let changeTextSizeButton = UIBarButtonItem(
      image: UIImage(named: "resize"),
      style: .Plain,
      target: self,
      action: Selector("changeTextSize:"))
    
    let moreOptionsButton = UIBarButtonItem(
      image: UIImage(named: "more"),
      style: .Plain,
      target: self,
      action: Selector("moreOptions:"))
    
    let toolbarItems = [fixedSpace, shareButton, flexibleSpace, favoriteButton, flexibleSpace, changeTextSizeButton, flexibleSpace, moreOptionsButton, fixedSpace]
    
    toolbar.setItems(toolbarItems, animated: false)
  }
  
  func setUpTitleLabel(label: UILabel) {
    guard let label = label as? ICLabel else { return }
    
    label.backgroundColor = .whiteColor()
    label.numberOfLines = 0
    label.font = UIFont.systemFontOfSize(27.0)
    label.text = previewTitleText
  }
  
  func setUpWebview() -> WKWebView {
    webview = WKWebView(frame: CGRect(
      x: 0.0,
      y: previewSize.height,
      width: screenSize.width,
      height: screenSize.height))
    webview.backgroundColor = .clearColor()
    webview.scrollView.userInteractionEnabled = false
    
    guard let url = NSURL(string: "https://www.github.com") else { return webview }
    webview.loadRequest(NSURLRequest(URL: url))
    
    return webview
  }
}

// MARK: - Actions
extension ThirdViewController {
  
  @IBAction func share(barButtonItem: UIBarButtonItem) {
    print("did tap share")
  }
  
  @IBAction func favorite(barButtonItem: UIBarButtonItem) {
    print("did tap favorite")
  }
  
  @IBAction func resize(barButtonItem: UIBarButtonItem) {
    print("did tap resize")
  }
  
  @IBAction func moreOptions(barButtonItem: UIBarButtonItem) {
    print("did tap more options")
  }
  
  func toTop(barButtonItem: UIBarButtonItem) {
    mainScrollView.setContentOffset(CGPoint(x: 0.0, y: initialOffset.y), animated: true)
  }
}
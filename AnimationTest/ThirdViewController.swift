//
//  ThirdViewController.swift
//  AnimationTest
//
//  Created by Bas Broek on 05/10/15.
//  Copyright © 2015 iCulture. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let width = UIScreen.mainScreen().bounds.size.width
    mainScrollView.contentSize = CGSize(width: width, height: 2_000)
    addViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension ThirdViewController {
  
  func addViews() {
    let purpleView = UIView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
    purpleView.backgroundColor = .purpleColor()
    
    let greenView = UIView(frame: CGRect(x: 150, y: 160, width: 150, height: 200))
    greenView.backgroundColor = .greenColor()
    
    let blueView = UIView(frame: CGRect(x: 40, y: 400, width: 200, height: 150))
    blueView.backgroundColor = .blueColor()
    
    let yellowView = UIView(frame: CGRect(x: 100, y: 600, width: 180, height: 150))
    yellowView.backgroundColor = .yellowColor()
    
    mainScrollView.addSubview(purpleView)
    mainScrollView.addSubview(greenView)
    mainScrollView.addSubview(blueView)
    mainScrollView.addSubview(yellowView)
  }
}
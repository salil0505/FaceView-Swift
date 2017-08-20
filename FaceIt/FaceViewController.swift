//
//  FaceViewController.swift
//  FaceIt
//
//  Created by Salil Thakur on 8/19/17.
//  Copyright © 2017 Salil Thakur. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
  
  @IBOutlet weak var faceView: FaceView! {
    didSet {
      let handler = #selector(FaceView.changeScale(byReactingTo:))
      let pinchRecognizer = UIPinchGestureRecognizer.init(target: faceView, action: handler)
      faceView.addGestureRecognizer(pinchRecognizer)
      
      let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(toggleEyes(byReactingTo:)))
      tapRecognizer.numberOfTapsRequired = 1
      faceView.addGestureRecognizer(tapRecognizer)
      
      let swipeUpRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(increaseHappiness))
      swipeUpRecognizer.direction = .down
      faceView.addGestureRecognizer(swipeUpRecognizer)
      
      let swipeDownRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(decreaseHappiness))
      swipeDownRecognizer.direction = .up
      faceView.addGestureRecognizer(swipeDownRecognizer)
      
      updateUI()
    }
  }
  
  func increaseHappiness() {
    expression = expression.happier
  }
  
  func decreaseHappiness() {
    expression = expression.sadder
  }
  
  func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
    if tapRecognizer.state == .ended {
      let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
      expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
    }
  }
  
  var expression = FacialExpression(eyes: .closed, mouth: .frown) {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    switch expression.eyes {
    case .open:
      faceView?.eyesOpen = true
    case .closed:
      faceView?.eyesOpen = false
    case .squinting:
      faceView?.eyesOpen = false
    }
    faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
  }
  
  private let mouthCurvatures = [
    FacialExpression.Mouth.frown: -1.0,
    .smirk: -0.5,
    .neutral: 0.0,
    .grin: 0.5,
    .smile: 1.0
  ]
  
}


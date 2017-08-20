//
//  FaceView.swift
//  FaceIt
//
//  Created by Salil Thakur on 8/19/17.
//  Copyright © 2017 Salil Thakur. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
  
  @IBInspectable
  var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
  
  func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
    switch pinchRecognizer.state {
    case .changed, .ended:
      scale *= pinchRecognizer.scale
      pinchRecognizer.scale = 1
    default:
      break
    }
  }
  
  private var skullRadius: CGFloat {
    return min(bounds.size.width, bounds.size.height) / 2 * scale
  }
  
  private var skullCenter: CGPoint {
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }
  
  private func pathForEye(_ eye: Eye) -> UIBezierPath {
    func centerOfEye(_ eye: Eye) -> CGPoint {
      let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
      var eyeCenter = skullCenter
      eyeCenter.y -= eyeOffset
      eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
      return eyeCenter
    }
    
    let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
    let eyeCenter = centerOfEye(eye)
    
    let path: UIBezierPath
    
    if eyesOpen {
      path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
    } else {
      path = UIBezierPath()
      path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
      path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
    }
    
    path.lineWidth = lineWidth
    
    return path
  }
  
  private func pathForMouth() -> UIBezierPath {
    let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
    let mouthHeight = skullRadius / Ratios.skullRadiusToEyeHeight
    let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
    
    let mouthRect = CGRect(
      x: skullCenter.x - mouthWidth / 2,
      y: skullCenter.y + mouthOffset,
      width: mouthWidth,
      height: mouthHeight
    )
    
    let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
    
    let start = CGPoint.init(x: mouthRect.minX, y: mouthRect.midY)
    let end = CGPoint.init(x: mouthRect.maxX, y: mouthRect.midY)
    
    let cp1 = CGPoint(x: start.x + mouthRect.width / 3,y: start.y + smileOffset)
    let cp2 = CGPoint(x: end.x - mouthRect.width / 3,y: start.y + smileOffset)
    
    let path = UIBezierPath()
    path.move(to: start)
    path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
    path.lineWidth = lineWidth
    
    return path
    
  }
  
  private enum Eye {
    case left
    case right
  }
  
  
  private func pathForSkill() -> UIBezierPath {
    let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
    path.lineWidth = lineWidth
    
    return path
  }
  
  override func draw(_ rect: CGRect) {
    
    color.set()
    pathForSkill().stroke()
    pathForEye(.left).stroke()
    pathForEye(.right).stroke()
    pathForMouth().stroke()
  }
  
  
  private struct Ratios {
    static let skullRadiusToEyeOffset: CGFloat = 3
    static let skullRadiusToEyeRadius: CGFloat = 10
    static let skullRadiusToMouthWidth: CGFloat = 1
    static let skullRadiusToEyeHeight: CGFloat = 3
    static let skullRadiusToMouthOffset: CGFloat = 3
  }
  
}

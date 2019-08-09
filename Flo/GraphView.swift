//
//  GraphView.swift
//  Flo
//
//  Created by MyeongSoo-Linne on 09/08/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    // 1 그라데이션을 위한 시작 색상과 끝 색상을 @IBInspectable속성으로 설정하면 storyboard에서 사용이 가능
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    override func draw(_ rect: CGRect) {
        
        // 2
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3 모든 context는 색상 공간(color space)를 가집, 프로젝트에서는 RGB
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5 실제 그라데이션 생성 -> 색상공간, 색상, stops
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        // 6 그라데이션 그리기 -> 필요 매개변수 (그리는 곳 CGContext, CGGradient[색상공간,색상들,stops])
        let startPoint = CGPoint.zero // 시작 점
        let endPoint = CGPoint(x: 0, y: bounds.height) // 종료점
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
}

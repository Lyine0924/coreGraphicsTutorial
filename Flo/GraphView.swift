//
//  GraphView.swift
//  Flo
//
//  Created by MyeongSoo-Linne on 09/08/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 5.0
}

@IBDesignable class GraphView: UIView {
    
    // 1 그라데이션을 위한 시작 색상과 끝 색상을 @IBInspectable속성으로 설정하면 storyboard에서 사용이 가능
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    // 그래프 x 축을 위한 변수 추가
    var graphPoints = [4,2,6,4,5,8,3]
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
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
        
        // calcuate the x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let colummXPoint = { (colum:Int) -> CGFloat in
            //calculate the between width
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(colum) * spacing + margin + 2
        }
        
        // calculate the y point
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // set up the points line
        let graphPath = UIBezierPath()
        
        // go to start of line
        graphPath.move(to: CGPoint(x: colummXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: colummXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //graphPath.stroke()
        
        //Create the clipping path for the graph radient
        
        // 1. - save the stata of the context (commented out for now)
        //context.saveGState()
        
        // 2 - make a copy of the path
        // 표시된 경로를 그라데이션으로 채울 영역을 정의하는 새 경로를 복사함
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        // 3 - add line to the copied path to completed the clip area
        // 구석의 점 영역으로 완려하고 경로를 닫음 ==> 그래프의 오른,왼쪽 하단이 추가됨
        clippingPath.addLine(to: CGPoint(x:colummXPoint(graphPoints.count-1),y: height))
        clippingPath.addLine(to: CGPoint(x:colummXPoint(0),y: height))
        clippingPath.close()
        
        // 4 - add the clipping path to the context
        //  컨텍스트가 채워졌을 때, 실제로 잘린 경로만 채워짐
        clippingPath.addClip()
        
        /*
        // 5 - check clipping path - temporary code
        // 컨텍스트 채우기 -> rect : draw에 전달된 컨텍스트 영역임
        UIColor.green.setFill()
        
        let rectPath = UIBezierPath(rect: rect)
        rectPath.fill()
        // end temporary code
        */
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        //context.restoreGState() //그래프의 표시된 점을 위한 원을 그리고 난 후 주석 처리를 지울 예정임
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
    }
}

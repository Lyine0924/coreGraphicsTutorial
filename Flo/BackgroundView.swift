//
//  BackgroundView.swift
//  Flo
//
//  Created by MyeongSoo-Linne on 12/08/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundView: UIView {

    //1
    @IBInspectable var lightColor:UIColor = UIColor.orange
    @IBInspectable var darkColor:UIColor = UIColor.yellow
    @IBInspectable var patternSize:CGFloat = 200
    
    override func draw(_ rect:CGRect){
        //2 뷰의 컨텍스트를 제공, draw 가 그려지는 장소임
        let context = UIGraphicsGetCurrentContext()
        
        //3 컨텍스트의 현재 색상을 채움
        context?.setFillColor(darkColor.cgColor)
        
        //4 현재 컨텍스트에 채운 색상으로 전체 컨텍스트를 채움
        context?.fill(rect)
    }
    

}

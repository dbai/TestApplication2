//
//  CanvasView.swift
//  TestApplication
//
//  Created by David Pai on 2020/4/17.
//  Copyright © 2020 GrandFunk. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 256, y: 0))
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 256, y: 10))
        path.stroke()
    }
    

}

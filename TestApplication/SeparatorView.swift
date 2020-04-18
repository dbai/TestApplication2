//
//  CanvasView.swift
//  TestApplication
//
//  Created by David Pai on 2020/4/17.
//  Copyright © 2020 GrandFunk. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
//        UIColor.red.set()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: 10))
        path.move(to: CGPoint(x: 0, y: 15))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: 15))
        path.stroke()
    }
    

}

//
//  Unit.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/20.
//

import Foundation
import SwiftUI

class Unit {
    let uuid = UUID().uuidString
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        lhs.uuid == rhs.uuid
    }
    var color = Color.green
    
    var center:CGPoint {
        .init(x: rect.origin.x + rect.size.width * 0.5,
              y: rect.origin.y + rect.size.height * 0.5)
    }
    
    var rect:CGRect = .init(x: .random(in: 50...250),
                            y: .random(in: 50...450),
                            width: 30,
                            height: 30)
    
    private var _radius:CGFloat? = nil
    var radius:CGFloat {
        if let value = _radius {
            return value
        }
        let result = (rect.width + rect.height) * 0.25
        _radius = result
        return result
    }
    
    var movement:CGSize = .init(width: .random(in: 0.1...0.5) * (Bool.random() ? -1.0 : 1.0) ,
                                height: .random(in: 0.1...0.5) * (Bool.random() ? -1.0 : 1.0))
                
    var lineWidth:CGFloat = 2.0
    
    var count = 0
    var limit = 1000
    
    var isLimitOver:Bool {
        count > limit
    }
    
    var opacity:Double {
        Double(limit - count) / Double(limit)
    }
    
    func draw(context:GraphicsContext) {        
        let color = self.color.opacity(opacity)
        context.stroke(
                Path(ellipseIn: rect),
                with: .color(color),
                lineWidth: lineWidth)
        count += 1
    }
    
    func process() {
        rect.origin.x += movement.width
        rect.origin.y += movement.height
    }
    
    func isCrash(targrt:Unit)->Bool {
        if(targrt == self) {
            return false
        }
        let distance = center.distance(to: targrt.center)
        return radius + targrt.radius > distance
    }
}

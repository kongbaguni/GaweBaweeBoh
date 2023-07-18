//
//  Unit.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/20.
//

import Foundation
import SwiftUI

class Unit {
    @AppStorage("unitSpeed") var unitSpeed:Double = Consts.unitSpeed
    let uuid = UUID().uuidString
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        lhs.uuid == rhs.uuid
    }
    var color = Color.green
    
    var center:CGPoint {
        .init(x: rect.origin.x + rect.size.width * 0.5,
              y: rect.origin.y + rect.size.height * 0.5)
    }
    var rect:CGRect {
        return .init(origin: origin, size: size)
    }

    let radius:CGFloat
    let size:CGSize
    var origin:CGPoint = .zero
    init(radius:CGFloat, origin:CGPoint) {
        self.radius = radius
        self.size = .init(width: radius*2, height: radius*2)
        self.origin = origin
    }
    
    
    
    var movement:CGSize = .init(width: .random(in: 0.1...0.5) * (Bool.random() ? -1.0 : 1.0) ,
                                height: .random(in: 0.1...0.5) * (Bool.random() ? -1.0 : 1.0))
                
    var lineWidth:CGFloat = 2.0
    
    var count = 0
        
    func draw(context:GraphicsContext) {        
        let color = self.color
        context.stroke(
                Path(ellipseIn: rect),
                with: .color(color),
                lineWidth: lineWidth)
        count += 1
    }
    
    func process() {
        origin.x += movement.width * unitSpeed
        origin.y += movement.height * unitSpeed
    }
    
    func isCrash(targrt:Unit)->Bool {
        if(targrt == self) {
            return false
        }
        let distance = center.distance(to: targrt.center)
        return radius + targrt.radius > distance
    }
}

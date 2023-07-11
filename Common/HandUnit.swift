//
//  HandUnit.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/21.
//

import Foundation
import SwiftUI

class HandUnit : Unit {
    enum Status : Int {
        case 가위 = 0
        case 바위 = 1
        case 보 = 2
        var stringValue:String {
            switch self {
            case .가위: return "가위"
            case .바위: return "바위"
            case .보: return "보"
            }
        }
        var colorValue:Color {
            switch self {
            case .가위: return .red
            case .바위: return .blue
            case .보: return .orange
            }
        }
        
        var imageView:some View {
            switch self {
            case .가위: return Image("gawee").resizable().scaledToFit()
            case .바위: return Image("bawee").resizable().scaledToFit()
            case .보: return Image("boh").resizable().scaledToFit()
            }
        }
    }
    
    var status:Status = .init(rawValue: .random(in: 0...2))!
    var ignoreTest = false
    
    init(status:Status) {
        self.status = status;
    }
    
    override func draw(context: GraphicsContext) {
        let w = rect.width 
        let h = rect.height
        let x = (rect.width - w) * 0.5 + rect.origin.x
        let y = (rect.height - w) * 0.5 + rect.origin.y
        let newRect = CGRect(x: x, y: y, width: w, height: h)
        self.color = status.colorValue
        super.draw(context: context)
        switch status {
        case .가위:
            context.draw(Image("gawee"), in: newRect)
        case .바위:
            context.draw(Image("bawee"), in: newRect)
        case .보:
            context.draw(Image("boh"), in: newRect)
        }
    }
    
    override func isCrash(targrt: Unit) -> Bool {
        let result = super.isCrash(targrt: targrt)
        guard let t = targrt as? HandUnit else {
            return result
        }
        
        var test:Int {
            switch(status) {
            case .가위:
                switch(t.status) {
                case .가위:
                    return 0
                case .바위:
                    return -1
                case .보:
                    return 1
                }
            case .바위:
                switch(t.status) {
                case .가위:
                    return 1
                case .바위:
                    return 0
                case .보:
                    return -1
                }

            case .보:
                switch(t.status) {
                case .가위:
                    return -1
                case .바위:
                    return 1
                case .보:
                    return 0
                }
            }
        }
        
        if result {
            switch test {
            case 1:
                t.status = status
            case -1:
                status = t.status
            default:
                break
            }
        }
        
        return result
    }
}

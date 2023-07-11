//
//  GameManager.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/21.
//

import Foundation
import SwiftUI

class GameManager {
    static let shared = GameManager()
    var units:[Unit] = []
    var size:CGSize = .zero
    
    func process() {
        for (idx,unit) in units.enumerated() {
//            unit.limit = Int(size.height * 2);
            unit.process()
            
            let test = size.isOver(rect: unit.rect)
            if(test.x) {
                unit.movement.width *= -1
            }
            if(test.y) {
                unit.movement.height *= -1
            }
                        
            for unit2 in units {
                if(unit.isCrash(targrt: unit2)) {
//                    unit.movement.width *= -1
//                    unit.movement.height *= -1
//                    unit2.movement.width *= -1
//                    unit2.movement.height *= -1
                }
            }
                        
        }
    }
    
    var data:[(Color,Int)] {
        var d:[Color:Int] = [:]
        for unit in units {
            if d[unit.color] == nil {
                d[unit.color] = 0
            } else {
                d[unit.color]! += 1
            }
        }
        var result:[(Color,Int)] = []
        for item in d {
            result.append(item)
        }
        result.sort { a, b in
            return a.1 > b.1
        }        
        
        return result
    }
}

//
//  CGSIze+Extensions.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/21.
//

import Foundation
extension CGSize {
    func isOver(rect:CGRect)->(x:Bool,y:Bool) {
        let x1 = rect.origin.x < 0
        let y1 = rect.origin.y < 0
        let x2 = rect.origin.x + rect.width > width
        let y2 = rect.origin.y + rect.height > height
        return (x:x1 || x2, y: y1 || y2)
    }
}

//
//  CGFloat+Extensions.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import Foundation
import SwiftUI

extension CGFloat {
    static var safeAreaInsetBottom:CGFloat {
        return ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom ?? 0) + 20
    }
}

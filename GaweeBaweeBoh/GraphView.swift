//
//  GraphView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import SwiftUI

struct GraphView: View {
    let data:[(Color,Int)]
    let total:Int
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                ForEach(0..<data.count, id: \.self) { idx in
                    let vw = proxy.size.width
                    let w = (CGFloat(data[idx].1) / Double(total)) * vw
                    data[idx].0
                        .frame(width: w)
                }
                
            }
        }
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GraphView(data: [
                (.yellow,40),
                (.green,30),
                (.red,30)
            ], total: 100)
            .frame(height: 50)
            Spacer()
        }
    }
}

//
//  GraphView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import SwiftUI

struct GraphView: View {
    let data:[(HandUnit.Status,Int)]
    let total:Int
    
    var body: some View {
        GeometryReader { proxy in
            HStack(
                alignment: .top,
                spacing: 0
            ) {
                ForEach(0..<data.count, id: \.self) { idx in
                    let vw = proxy.size.width
                    let w = (CGFloat(data[idx].1) / CGFloat(total)) * vw
                    ZStack {
                        Rectangle()
                            .foregroundColor(data[idx].0.colorValue)
                        HStack {
                            data[idx].0.imageView
                                .padding(.leading,5)
                                .shadow(radius: 10)
                            Spacer()
                        }
                            
                    }.frame(width: w)
                }
            }.background(Color.backgroundColor1)
        }
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GraphView(data: [
                (.가위,40),
                (.바위,30),
                (.보,30)
            ], total: 100)
            .frame(height: 50)
            Spacer()
        }.background(Color.yellow)
    }
}

//
//  ImageView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/11.
//

import SwiftUI
struct ImageView: View {
    @State var uiImage:UIImage?
    var body: some View {
        Image(uiImage: uiImage ?? .init(named:"gawee")!)
            .resizable()
            .scaledToFit()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(uiImage:nil)
    }
}

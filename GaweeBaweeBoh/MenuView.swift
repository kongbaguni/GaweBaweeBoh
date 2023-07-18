//
//  MenuView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/18.
//

import SwiftUI

struct MenuView: View {
    @AppStorage("unitLimit") var unitLimit:Double = 100
    @AppStorage("unitSpeed") var unitSpeed:Double = 0
    @AppStorage("unitSize") var unitSize:Double = 0.015
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Unit Limit")
                        Text("\(Int(unitLimit))").foregroundColor(.indigo)
                    }
                    Slider(value: $unitLimit, in: 50...500)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Unit Speed")
                        Text("\(unitSpeed)").foregroundColor(.indigo)
                    }
                    Slider(value: $unitSpeed, in: 0.01...5.0)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Unit Size")
                        Text("\n\(unitSize*100)").foregroundColor(.indigo)
                    }
                    Slider(value: $unitSize, in: 0.01...0.05)
                }
            }
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("confirm")
                    .padding(20)
            }

        }
        .navigationTitle(Text("setting"))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

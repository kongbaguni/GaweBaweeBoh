//
//  MenuView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/18.
//

import SwiftUI

struct MenuView: View {
    @State var unitLimit = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            List {
                HStack {
                    Text("Unit Limit")
                    TextField(text: $unitLimit) {
                        Text("100")
                    }.keyboardType(.numberPad)
                }
            }
            Button {
                UserDefaults.standard.unitLimit = NSString(string:unitLimit).integerValue
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("confirm")
                    .padding(20)
            }

        }
        .navigationTitle(Text("setting"))
        .onAppear {
            unitLimit = "\(UserDefaults.standard.unitLimit)"
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

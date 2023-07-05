//
//  ContentView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/20.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var csize:CGFloat = 100
    @State var width:CGFloat = 4.0
    @State var count = 0
    var top:CGFloat {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0
    }
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { noti in
            AppGroup().saveGameData()
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    @State var data:[(HandUnit.Status,Int)] = []
    @State var total = 0
    var body: some View {
        VStack {
            Canvas{context,size in
                GameManager.shared.size = size
                context.draw(Text("unit : \(GameManager.shared.units.count) count : \(count)"), in: .init(x: 10, y: -top, width: 200, height: 50))
                var d:[HandUnit.Status:Int] = [:]
                for unit in GameManager.shared.units {
                    unit.draw(context: context)
                    if let status = (unit as? HandUnit)?.status {
                        if(d[status] == nil) {
                            d[status] = 0
                        } else {
                            d[status]! += 1
                        }
                    }
                }
                DispatchQueue.main.async {
                    total = GameManager.shared.units.count
                    data = []
                    for i in d {
                        data.append(i)
                    }
                    data.sort { a, b in
                        return a.1 > b.1
                    }

                }
                
                if(count % 10 == 0) {
                    GameManager.shared.units.append(HandUnit(status: HandUnit.Status(rawValue: (count / 10) % 3)!))
                }
            }
            GraphView(data: data, total: total)
            .frame(height: 50)
            .padding(.bottom,.safeAreaInsetBottom)

                        
//            HStack {
//                Button {
//                    GameManager.shared.units.append(HandUnit(status: .가위))
//                } label: {
//                    Text("가위")
//                }
//                Button {
//                    GameManager.shared.units.append(HandUnit(status: .바위))
//                } label: {
//                    Text("바위")
//                }
//                Button {
//                    GameManager.shared.units.append(HandUnit(status: .보))
//                } label: {
//                    Text("보")
//                }
//
//            }
//            .padding(.bottom,
//                     (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom ?? 0)

        }
        .ignoresSafeArea(.all)
        .onAppear {
            startUpdate()
        }
    }
    
    func startUpdate() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { timer in
            count += 1
            GameManager.shared.process()
        }
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

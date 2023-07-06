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
    let colors:[Color] = [
        .random, .random, .random,.random, .random,.random,.random,.random, .random,.random, .random,.random
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Canvas{ context,size in
                    GameManager.shared.size = size
                    for i in 0...10 {
                        let a = CGFloat((count + i * 52) % Int(size.width / 2))
                        let rectangle = CGRect(
                            x: a,
                            y: a ,
                            width: size.width - a * 2,
                            height: size.height - a * 2)
                        let color = colors[i % colors.count].opacity(0.5)
                        context.stroke(Path(rectangle), with: .color(color), lineWidth: CGFloat(i+1))
                    }
                    
                    context.draw(Text("unit : \(GameManager.shared.units.count) count : \(count)"), in: .init(x: 10, y: 100, width: 200, height: 50))
                    
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
                    .frame(height: 30)
                    .padding(.bottom,.safeAreaInsetBottom)
                
                
            }
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

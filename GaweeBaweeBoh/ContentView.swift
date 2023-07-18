//
//  ContentView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/05/20.
//

import SwiftUI
import WidgetKit
import GoogleMobileAds

struct ContentView: View {
    @AppStorage("unitLimit") var unitLimit:Double = Consts.unitLimit
    @AppStorage("unitSpeed") var unitSpeed:Double = Consts.unitSpeed
    @AppStorage("unitSize") var unitSize:Double = Consts.unitSize
    
    @State var csize:CGFloat = 100
    @State var width:CGFloat = 4.0
    @State var count = 0
    @State var isPushMenu = false
    var top:CGFloat {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0
    }
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { noti in
            AppGroup.saveGameData()
        }
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { noti in
            GameManager.shared.units.removeAll()
            //            for unit in GameManager.shared.units {
            //
            //            }
        }
        GADMobileAds.sharedInstance().start()
    }
    
    @State var data:[(HandUnit.Status,Int)] = []
    
    @State var total = 0
    let colors:[Color] = [
        .random, .random, .random,.random, .random,.random,.random,.random, .random,.random, .random,.random
    ]
    
    var canvasView : some View {
        GeometryReader { proxy in
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
                
                context.draw(
                    Text("\(GameManager.shared.units.count)").foregroundColor(.random).font(.largeTitle).bold(),
                    in: .init(x: 20, y: .safeAreaInsetTop , width: 200, height: 50))
                
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
                
                if GameManager.shared.units.count < Int(unitLimit) {
                    let w = proxy.size.width
                    let h = proxy.size.height
                    
                    let radius = (w + h) * unitSize
                    
                    GameManager.shared.units.append(
                        HandUnit(status: HandUnit.Status(rawValue: (count / 10) % 3)!,
                                 radius: radius,
                                 origin: .init(x:.random(in: radius*2..<w - radius*2) ,
                                               y:.random(in: radius*2..<h - radius*2))
                                )
                    )
                }
            }
        }
        .background(Color.backgroundColor1)
        .edgesIgnoringSafeArea(.all)
    }
    
    var adView : some View {
        Group {
            BannerAdView(sizeType: .GADAdSizeBanner, padding: .zero)
                .border(Color.black, width: 2).padding(5)
            AdView().zIndex(-1)
                .background(Color.backgroundColor2)
        }
    }
    
    var graphView : some View {
        Button {
            GameManager.shared.units.removeAll()
        } label: {
            GraphView(data: data, total: total)
                .frame(height: 30)
//                .padding(.bottom,.safeAreaInsetBottom)
        }
        .background(Color.backgroundColor1)
    }
    
    var body: some View {
        NavigationView {
            VStack (
                alignment: .center,
                spacing: 0
            ) {
                ZStack {
                    canvasView
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: MenuView()) {
                                Image(systemName: "line.3.horizontal")
                                    .imageScale(.large)
                                    .padding(10)
                                    .background(Color.white).opacity(0.8)
                                    .cornerRadius(10)
                                    .padding(10)
                            }
                        }
                        Spacer()
                    }
                }
                graphView
                adView
            }
            .background(Color.backgroundColor2)
            .onAppear {
                startUpdate()
            }
            .navigationBarTitleDisplayMode(.inline)
            
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

//
//  AdView.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/11.
//

import SwiftUI
import GoogleMobileAds
import ActivityIndicatorView

#if DEBUG
fileprivate let adId = "ca-app-pub-3940256099942544/3986624511"
#else
fileprivate let adId = "ca-app-pub-7714069006629518/1560510288"
#endif

struct AdSubView : UIViewRepresentable {
    let receiveAd:(_ adinfo:GADNativeAd)->()
    func makeUIView(context: Context) -> some UIView {
        let view = AdLoaderView { adinfo in
            receiveAd(adinfo)
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct AdView : View {
    @State var headline:String? = nil
    @State var bodyStr:String? = nil
    @State var adImage:Image? = nil
    @State var advertiser:String? = nil
    @State var callToAction:String? = nil
    @State var price:String? = nil
    @State var starRating:NSDecimalNumber? = nil
    @State var images:[UIImage] = []
    @State var store:String? = nil
    @State var isloading = true
    var body: some View {
        ZStack {
            AdSubView { [self] adinfo in
                if let uiimage = adinfo.icon?.image {
                    adImage = Image(uiImage: uiimage)
                }
                advertiser = adinfo.advertiser
                callToAction = adinfo.callToAction
                headline = adinfo.headline
                bodyStr = adinfo.body
                starRating = adinfo.starRating
                price = adinfo.price
                images = adinfo.images?.map({ image in
                    return image.image ?? UIImage()
                }) ?? []
                store = adinfo.store
                isloading = false
                
            }.frame(height: 1)
            ActivityIndicatorView(isVisible: $isloading, type: .default())
                .frame(width: 40, height: 40)

            VStack {
                HStack {
                    ScrollView {
                        if let img = adImage {
                            img.resizable().scaledToFit().frame(height: 80)
                        }
                        ForEach(images, id: \.self) { image in
                            Image(uiImage: image).resizable().scaledToFit().frame(height: 80)
                        }
                    }
                    .padding(.trailing,5)
                    .frame(width:80,height: 80)
                    
                    VStack {
                        if let txt = headline {
                            HStack {
                                Text(txt).font(.headline)
                                Spacer()
                            }
                        }
                        if let txt = bodyStr {
                            HStack {
                                Text(txt).font(.caption)
                                Spacer()
                            }
                        }
                        if let txt = advertiser {
                            HStack {
                                Text(txt).font(.caption)
                                Spacer()
                            }
                        }
                        if let txt = store {
                            HStack {
                                Text(txt).font(.caption)
                                Spacer()
                            }
                        }
                        HStack {
                            if let value = starRating {
                                if(value.doubleValue > 0) {
                                    StarView(rating: value, color: .orange)
                                        .frame(width: 100)
                                }
                            }
                            if let txt = price {
                                Text("price :")
                                Text(txt)
                            }
                            Spacer()
                            if let txt = callToAction {
                                Button {
                                    if let advertiser = advertiser {
                                        if let url = URL(string: advertiser) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                } label: {
                                    Text(txt)
                                }
                            }
                        }
                    }

                }
            }.padding(10)
            
           

        }
    }
}

class AdLoaderView : UIView {
    let loader:GADAdLoader
    let receiveAd:(_ adinfo:GADNativeAd)->()
    var pauseRequest = false
    init(receiveAd:@escaping(_ adinfo:GADNativeAd)->()) {
        self.receiveAd = receiveAd
        let option = GADMultipleAdsAdLoaderOptions()
        option.numberOfAds = 1
        self.loader = GADAdLoader(adUnitID: adId,
                                  rootViewController: UIApplication.topViewController,
                                  adTypes: [.native],
                                  options: [option])
        super.init(frame: .zero)
        self.loader.delegate = self
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] noti in
            self?.pauseRequest = true
        }
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] noti in
            self?.pauseRequest = false
            self?.loadAd()
        }
        loadAd()
    }
    
    func loadAd() {
        guard pauseRequest == false else {
            return
        }
        loader.load(.init())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) { [weak self] in
            self?.loadAd()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdLoaderView : GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        nativeAd.enableCustomClickGestures()
        nativeAd.registerClickConfirmingView(self)
        nativeAd.recordCustomClickGesture()
        print("nativeAdDelegate : setDelegate \(nativeAd.isCustomClickGestureEnabled)")
        
        self.receiveAd(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print(error.localizedDescription)
        
    }
    
}


extension AdLoaderView : GADNativeAdDelegate {
    func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    func nativeAdDidRecordSwipeGestureClick(_ nativeAd: GADNativeAd) {
        print("nativeAdDelegate : \(#function) \(#line)")
    }
    
}

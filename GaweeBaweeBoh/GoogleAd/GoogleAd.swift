//
//  GoogleADViewController.swift
//  firebaseTest
//
//  Created by Changyul Seo on 2020/03/13.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

#if DEBUG
fileprivate let gaid = "ca-app-pub-3940256099942544/6978759866" // test ga id
fileprivate let bannerGaId = "ca-app-pub-3940256099942544/2934735716" // test ga id
#else
fileprivate let gaid = "ca-app-pub-7714069006629518/9056814781" // real ga id
fileprivate let bannerGaId = "ca-app-pub-7714069006629518/8561673537" // real ga id
#endif



class GoogleAd : NSObject {
    
    var interstitial:GADRewardedAd? = nil
    private func requestTrackingAuthorization(complete:@escaping()->Void) {
        ATTrackingManager.requestTrackingAuthorization { status in
            print("google ad tracking status : \(status)")
            complete()
        }
    }
    
    private func loadAd(complete:@escaping(_ isSucess:Bool)->Void) {
        let request = GADRequest()
        requestTrackingAuthorization {
            GADRewardedAd.load(withAdUnitID: gaid, request: request) { [weak self] ad, error in
                if let err = error {
                    print("google ad load error : \(err.localizedDescription)")
                }
                ad?.fullScreenContentDelegate = self
                self?.interstitial = ad
                complete(ad != nil)
            }
        }
    }
    
    var callback:(_ isSucess:Bool, _ time:TimeInterval?)->Void = { _,_ in}
    
    var requstAd = false
    func showAd(complete:@escaping(_ isSucess:Bool, _ time:TimeInterval?)->Void) {
        if requstAd {
            return
        }
        requstAd = true
        let now = Date()
        if let lastTime = UserDefaults.standard.lastAdWatchTime {
            let interval = now.timeIntervalSince1970 - lastTime.timeIntervalSince1970
            if interval < 60 {
                complete(false,interval)
                return
            }
        }
        callback = complete
        loadAd { [weak self] isSucess in
            if isSucess == false {
                DispatchQueue.main.async {
                    complete(true,nil)
                }
                return
            }
            self?.requstAd = false
            UserDefaults.standard.lastAdWatchTime = Date()
                        
            if let vc = UIApplication.shared.lastViewController {
                self?.interstitial?.present(fromRootViewController: vc, userDidEarnRewardHandler: {
                    
                })
            }
        }
    }
}
extension GoogleAd : GADFullScreenContentDelegate {
    //광고 실패
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("google ad \(#function)")
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.callback(true, nil)
        }
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고시작
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고 종료
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
        DispatchQueue.main.async {
            self.callback(true, nil)
        }
    }
}

struct GoogleAdBannerView: UIViewRepresentable {
    let bannerView:GADBannerView
    func makeUIView(context: Context) -> GADBannerView {
        bannerView.adUnitID = bannerGaId
        bannerView.rootViewController = UIApplication.shared.lastViewController
        return bannerView
    }
  
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        uiView.load(GADRequest())
    }
}

//
//  BannerViewModel.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/02/17.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import Foundation
import GoogleMobileAds
import UIKit

class BannerViewModel {
    
    let isBannerTest = false
    let isSimulatorTest = false
    
    let bannerView: GADBannerView
    
    // バナー広告 初期化
    init(rootViewController: UIViewController) {
        
        // バナー広告のViewを初期化
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        // 親のViewControllerを設定
        bannerView.rootViewController = rootViewController
        
        // 横幅を親のViewに合わせる
        bannerView.frame.size = CGSize(width: rootViewController.view.frame.size.width,
                                       height: bannerView.frame.height)
        
        // ソース上でAutoLayoutを使用
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 広告リクエストを設定
        let request = GADRequest()
        
        // 広告ユニットIDを設定
        if isBannerTest {
            // テスト用のユニットIDを設定
            bannerView.adUnitID = "テストユニットID"
            
            // テストデバイスを設定
            if isSimulatorTest {
                // シミュレーター
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [(kGADSimulatorID as! String)]
            } else {
                // 実機(IDを設定する必要アリ)
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["実機ID"]
            }
            
        } else {
            // 本番用のユニットIDを設定
            bannerView.adUnitID = "本番ユニットID"
        }
        
        // バナー広告 ロード
        bannerView.load(request)
    }
}

//
//  NavigationController.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/02/15.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 色設定値を反映
        if Defaults[\.themeColor] == nil {
            Defaults[\.themeColor] = UIColor.defaultTheme
        }

        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = Defaults[\.themeColor]
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
}

extension UINavigationController {
    // ステータスバーの文字色変更
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

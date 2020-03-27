//
//  DefaultsKeys.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/02/11.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    // ユーザーID
    var userID: DefaultsKey<String?> { return .init("userID") }
    // テーマカラー
    var themeColor: DefaultsKey<UIColor?> { return .init("themeColor")}
    // 購入フラグ
    var isPaying: DefaultsKey<Bool?> { return .init("isPaying")}
}

// UIColorをキーに追加
extension UIColor: DefaultsSerializable {}

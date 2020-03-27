//
//  Double+formattedString.swift
//  Desires
//
//  Created by Kohei Nishino on 2019/12/16.
//  Copyright © 2019 Kohei Nishino. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = NumberFormatter()

extension Double {
    
    private func formattedString(style: NumberFormatter.Style, localeIdentifier: String) -> String {
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    // カンマ区切りString
    var formattedJPString: String {
        return formattedString(style: .decimal, localeIdentifier: "ja_JP")
    }
    
    // 日本円表記のString
    var JPYString: String {
        return formattedString(style: .currency, localeIdentifier: "ja_JP")
    }
    
    // USドル表記のString
    var USDString: String {
        return formattedString(style: .currency, localeIdentifier: "en_US")
    }
}

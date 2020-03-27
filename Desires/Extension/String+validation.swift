//
//  String+validation.swift
//  Desires
//
//  Created by Kohei Nishino on 2019/12/28.
//  Copyright © 2019 Kohei Nishino. All rights reserved.
//

import Foundation

extension String {

    // 数字
    public static let structureOfNumber = "0123456789"

    // 小英字
    public static let structureOfLowercaseAlphabet = "abcdefghijklmnopqrstuvwxyz"

    // 大英字
    public static let structureOfUppercaseAlphabet = structureOfLowercaseAlphabet.uppercased()

    // 英字
    public static let structureOfAlphabet = structureOfLowercaseAlphabet + structureOfUppercaseAlphabet

    // 英数字
    public static let structureOfAlphabetAndNumber = structureOfAlphabet + structureOfNumber
    
    // ベースメソッド
    public func isOnly(structuredBy chars: String) -> Bool {
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: chars)
        return trimmingCharacters(in: characterSet as CharacterSet).count <= 0
    }

    // 半角数字のみで構成されているかどうか
    public var isOnlyNumber: Bool {
        let chars = String.structureOfNumber
        return isOnly(structuredBy: chars)
    }

    // 半角アルファベットのみで構成されているかどうか
    public var isOnlyAlphabet: Bool {
        let chars = String.structureOfAlphabet
        return isOnly(structuredBy: chars)
    }

    // 半角英数字のみで構成されているかどうか
    public var isOnlyAlphabetAndNumber: Bool {
        let chars = String.structureOfAlphabetAndNumber
        return isOnly(structuredBy: chars)
    }
    
    // 正しいURLの形成でで構成されているかどうか
    var isUrl: Bool {
        // リンク型のチェックタイプを指定
        let linkValidation = NSTextCheckingResult.CheckingType.link.rawValue
        // 検出オブジェクトを作成
        guard let detector = try? NSDataDetector(types: linkValidation) else { return false }
        // 渡された文字列からURLを検出
        let results = detector.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
        // NSTextCheckingResult型の配列の先頭のURL型が存在した場合（検出結果が存在する場合）、Trueを返す
        return results.first?.url != nil
     }
}

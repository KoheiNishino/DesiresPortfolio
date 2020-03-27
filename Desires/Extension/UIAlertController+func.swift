//
//  UIAlertController+func.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/02/09.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    // 通常メッセージ(OKのみ)
    static func okAlert(title: String?,
                        message: String?,
                        okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: okHandler))
        return alert
    }
    
    // 通常メッセージ（OK or Cancel）
    static func okOrCancelAlert(title: String?,
                                message: String?,
                                handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: handler))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    // Error
    static func errorAlert(title: String? = "⚠️",
                           error: Error,
                           okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: "\(error)", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: okHandler))
        return alert
    }
    
}

extension UIViewController {
    func present(_ alert: UIAlertController, completion: (() -> Void)? = nil) {
        present(alert, animated: true, completion: completion)
    }
}

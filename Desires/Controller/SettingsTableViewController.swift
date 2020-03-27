//
//  SettingsTableViewController.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/01/04.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import UIKit
import SafariServices

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // セルタップ時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セクションごとに分岐
        switch indexPath.section {
        case 0:
            supportSectionAction(indexPathRow: indexPath.row)
        default:
            break
        }
    }
    
    func supportSectionAction(indexPathRow row: Int) {
        // セルごとに分岐
        var link = ""
        switch row {
        case 0:
            // アプリのフィードバック
            guard let url = URL(string: "https://itunes.apple.com/app/id1503641521?action=write-review") else { return }
            UIApplication.shared.open(url)
            break
        case 1:
            // お問い合わせ・不具合のご連絡
            link = "https://docs.google.com/forms/d/e/1FAIpQLSeXJjHAKm84VUbwedS4SFuo0xBUy86g2rPOVzpfLb3ha1C9WQ/viewform?usp=sf_link"
        case 2:
            // プライバシーポリシー
            link = "https://koheinishino.github.io/Documents/Desires/privacy_policy"
        default:
            break
        }
        
        // Webブラウザを表示
        let url = URL(string: link)
        if let url = url {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}

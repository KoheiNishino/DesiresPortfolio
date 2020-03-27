//
//  MainTableViewCell.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/02/27.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import UIKit
import SafariServices

protocol UITableViewCellDelegate: class {
    func openBrowser(_ urlString: String)
}

class MainTableViewCell: UITableViewCell {
    
    weak var delegate: UITableViewCellDelegate!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    var itemLink: String!
    
    
    // セル作成
    func setupCell(itemModel: MainTableViewItemModel) {
        nameLabel.text = itemModel.itemName
        feeLabel.text = (itemModel.itemFee).JPYString
        itemLink = itemModel.itemURL
        
        // URLが登録されていない場合、ボタンを使用不可
        if itemLink.isEmpty {
            urlButton.isEnabled = false
            urlButton.isHidden = true
        } else {
            urlButton.isEnabled = true
            urlButton.isHidden = false
        }
    }
    
    // URLボタンタップ時
    @IBAction func urlButtonTouchUpInside(_ sender: Any) {
        // Webブラウザを表示
        delegate?.openBrowser(itemLink)
    }
}

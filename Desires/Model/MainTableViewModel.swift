//
//  MainTableViewModel.swift
//  Desires
//
//  Created by Kohei Nishino on 2020/03/06.
//  Copyright © 2020 Kohei Nishino. All rights reserved.
//

import Foundation
import RealmSwift

class MainTableViewListModel: Object {
    @objc dynamic var listNo: Int = 0
    @objc dynamic var listName: String = "list0"
    let listItems = List<MainTableViewItemModel>()
}

class MainTableViewItemModel: Object {
    @objc dynamic var itemNo: Int = 0
    @objc dynamic var itemName: String = "item0"
    @objc dynamic var itemFee: Double = 0
    @objc dynamic var itemURL: String = ""
}

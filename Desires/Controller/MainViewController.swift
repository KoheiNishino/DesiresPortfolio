//
//  MainViewController.swift
//  Desires
//
//  Created by Kohei Nishino on 2019/11/20.
//  Copyright © 2019 Kohei Nishino. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD
import RealmSwift
import SafariServices

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewCellDelegate {
    
    @IBOutlet weak var settingsButton: UINavigationItem!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var totalFeeLabel: UILabel!
    @IBOutlet weak var addAndDeleteButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    
    var itemModelResults: Results<MainTableViewItemModel>!
    var selectedRow: Int!
    
    // 表示するセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModelResults.count
    }
    
    // 表示するセル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MainTableViewCell
        cell.setupCell(itemModel: itemModelResults[indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
    
    // Webブラウザを表示
    func openBrowser(_ urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegateを設定
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        // カスタムセルのxibを登録
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        
        // 編集ボタンを左上に配置
        initEditButton(title: "編集", image: UIImage(systemName: "plus")!, backgroundColor: Defaults[\.themeColor]!)
        navigationItem.leftBarButtonItem = editButtonItem
        
        // 編集中において、TableViewの複数選択を許可
        mainTableView.allowsMultipleSelectionDuringEditing = true
        
        // 合計金額ラベルをリセット
        totalFeeLabel.text =  0.JPYString
        
        // SVProgressHUD 初期化
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        // 無課金の場合、バナー広告をセット
        if Defaults[\.isPaying] != true {
            Defaults[\.isPaying] = false
            setBannerView()
        }
        
        // Realmから保存データを取得
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        if let result = realm.objects(MainTableViewListModel.self).first {
            itemModelResults = result.listItems.sorted(byKeyPath: "itemNo", ascending: true)
        } else {
            // リストを作成
            let listModel = MainTableViewListModel()
            try! realm.write {
                realm.add(listModel)
            }
            // 再度取得
            if let result = realm.objects(MainTableViewListModel.self).first {
                itemModelResults = result.listItems.sorted(byKeyPath: "itemNo", ascending: true)
            }
        }
        
        // セルの合計金額をラベルに表示
        calcTotalFee()
    }
    
    // バナー広告をセット
    func setBannerView() {
        let bannerViewModel = BannerViewModel.init(rootViewController: self)
        let bannerView = bannerViewModel.bannerView
        self.view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: mainTableView.bottomAnchor, constant: 0).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    
    // 編集ボタンタップ時
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        //tableViewの編集モードを切り替える
        mainTableView.setEditing(editing, animated: animated)
        
        if isEditing {
            initEditButton(title: "完了", image: UIImage(systemName: "trash")!, backgroundColor: UIColor.systemRed)
            self.settingsBarButton.isEnabled = false
            self.settingsBarButton.tintColor = UIColor.clear
        } else {
            initEditButton(title: "編集", image: UIImage(systemName: "plus")!, backgroundColor: Defaults[\.themeColor]!)
            self.settingsBarButton.isEnabled = true
            self.settingsBarButton.tintColor = UIColor.white
        }
    }
    
    // 編集ボタン初期化
    func initEditButton(title: String, image: UIImage, backgroundColor: UIColor) {
        editButtonItem.title = title
        addAndDeleteButton.setImage(image, for: .normal)
        addAndDeleteButton.backgroundColor = backgroundColor
    }
    
    // セルの合計金額をラベルに表示
    func calcTotalFee() {
        var totalFee: Double = 0
        for itemModel in itemModelResults {
            totalFee += itemModel.itemFee
        }
        totalFeeLabel.text =  totalFee.JPYString
    }
    
    //並び替え可能に
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //並べ替えた結果を配列に適用
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Realmを変更
        let realm = try! Realm()
        try! realm.write {
            // 移動するモデルと移動先のモデルを取得
            let sourceItemModel = itemModelResults[sourceIndexPath.row]
            let destinationItemModel = itemModelResults[destinationIndexPath.row]
            
            // 移動先のモデルのNo.を取得
            let destinationItemNo = destinationItemModel.itemNo

            if sourceIndexPath.row < destinationIndexPath.row {
                // 上から下に移動した場合、No.をデクリメント（前に詰める）
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let itemModel = itemModelResults[index]
                    itemModel.itemNo -= 1
                }
            } else {
                // 下から上に移動した場合、No.をインクリメント（後ろに詰める）
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed(){
                    let itemModel = itemModelResults[index]
                    itemModel.itemNo += 1
                }
            }

            // 移動したモデルのNo.を移動先に更新
            sourceItemModel.itemNo = destinationItemNo
        }
    }
    
    // 項目セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 編集モードではない場合、編集画面に遷移させない
        if isEditing {
            return
        }
        
        // タップされた行のindexを格納
        if let selectedIndexPath = mainTableView.indexPathForSelectedRow {
            selectedRow = selectedIndexPath.row
        } else {
            present(.okAlert(title: "選択エラー", message: "タップされた項目を取得できませんでした。"))
            return
        }
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 変更画面に遷移
        performSegue(withIdentifier: "toEditView", sender: nil)
    }
    
    // Segue実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segueの識別子確認
        if segue.identifier == "toEditView" && selectedRow != nil {
            let nextView = segue.destination as! EditViewController
            nextView.selectedRow = selectedRow
            nextView.beforeName = itemModelResults[selectedRow].itemName
            
            // 日本円の場合、金額は整数部分のみ表示
            nextView.beforeFee = String(Int(itemModelResults[selectedRow].itemFee))
            
            nextView.beforeURL = itemModelResults[selectedRow].itemURL
        }
    }
    
    // 追加・削除ボタンタップ時
    @IBAction func addAndDeleteButtonTouchUpInside(_ sender: Any) {
        
        // 編集モードではない場合、追加画面へ遷移
        if isEditing == false {
            
            if itemModelResults.count >= 99 {
                present(.okAlert(title: "制限エラー", message: "申し訳ございません。\n項目は99個までしか登録できません。"))
                return
            }
            
            selectedRow = nil
            performSegue(withIdentifier: "toEditView", sender: nil)
            return
        }
        
        // 削除ボタン処理
        
        // 項目が選択されていない場合、エラーメッセージを表示
        guard let indexPaths = mainTableView.indexPathsForSelectedRows else {
            present(.okAlert(title: "選択エラー", message: "項目が選択されていません。"))
            return
        }
        
        // 選択項目のIndexPathを選択順ではなく、数値の降順にソート
        let sortedIndexPaths = indexPaths.sorted { $0.row > $1.row }
        
        // Realmを更新
        let realm = try! Realm()
        try! realm.write {
            // Indexがずれないように、配列の後ろから削除
            for indexPath in sortedIndexPaths {
                let itemModelResult = itemModelResults[indexPath.row]
                realm.delete(itemModelResult)
            }
            
            // モデルのNo.を更新
            for (index, itemModel) in itemModelResults.enumerated() {
                itemModel.itemNo = index
            }
        }
        
        // セルの合計金額をラベルに表示
        calcTotalFee()
        
        // 項目をTableViewから削除
        mainTableView.deleteRows(at:sortedIndexPaths, with: UITableView.RowAnimation.automatic)
    }
    
}

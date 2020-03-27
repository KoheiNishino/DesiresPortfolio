//
//  EditViewController.swift
//  Desires
//
//  Created by Kohei Nishino on 2019/12/29.
//  Copyright © 2019 Kohei Nishino. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD
import RealmSwift

class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var activeTextField: UITextField!   // 編集中のTextField
    var selectedRow: Int!               // 前画面で選択したセルの行
    var beforeName: String! = ""        // 前画面で選択したセルの名前
    var beforeFee: String! = ""         // 前画面で選択したセルの金額
    var beforeURL: String! = ""         // 前画面で選択したセルのURL
    
    // Viewの読み込み
    override func loadView() {
        if let view = UINib(nibName: "EditView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 各TextField 初期化
        initTextField()
        
        // テーマカラー設定
        editButton.backgroundColor = Defaults[\.themeColor]
        cancelButton.backgroundColor = Defaults[\.themeColor]
        
        // 変更画面で表示する場合、各項目を設定
        if selectedRow != nil {
            initChangeView()
        }
        
    }
    
    // TextField 初期化
    func initTextField() {
        // 名前のTextField
        nameTextField.text = ""
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = .next
        nameTextField.textAlignment = .left
        nameTextField.becomeFirstResponder()
        
        // 金額のTextField
        feeTextField.text = ""
        feeTextField.keyboardType = .numberPad
        feeTextField.returnKeyType = .next
        feeTextField.textAlignment = .left
        
        // URLのTextField
        urlTextField.text = ""
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .done
        urlTextField.textAlignment = .left
        
        // delegateを設定
        nameTextField.delegate = self
        feeTextField.delegate = self
        urlTextField.delegate = self
    }
    
    // 変更画面 初期化
    func initChangeView() {
        
        // ボタンの表記を変更
        editButton.setTitle("変更", for: .normal)
        
        // 前画面でタップされた名前と金額を表示
        nameTextField.text = beforeName
        feeTextField.text = beforeFee
        urlTextField.text = beforeURL
    }
    
    // 編集ボタン タップ
    @IBAction func tappedEditButton(_ sender: Any) {

        // 入力値を格納
        let itemName = nameTextField.text ?? ""
        let itemFee = feeTextField.text ?? ""
        let itemURL = (urlTextField.text ?? "").trimmingCharacters(in: .whitespaces)
        
        // 入力値チェック
        if validateInputs(itemName: itemName, itemFee: itemFee, itemURL: itemURL) == false {
            return
        }
        
        // ローディング処理 開始
        SVProgressHUD.show(withStatus: "Updating…")
        
        // Realmからリストを取得
        let realm = try! Realm()
        guard let listResults = realm.objects(MainTableViewListModel.self).first else { return }
        let listItems = listResults.listItems
        
        // 追加 or 変更
        if selectedRow == nil {
            // Realmにデータを追加
            let itemModel = MainTableViewItemModel()
            itemModel.itemNo = listItems.count
            itemModel.itemName = itemName
            itemModel.itemFee = Double(itemFee)!
            itemModel.itemURL = itemURL
            
            try! realm.write {
                listResults.listItems.append(itemModel)
            }
        } else {
            // Realmのデータを更新
            try! realm.write {
                listItems[selectedRow].itemName = itemName
                listItems[selectedRow].itemFee = Double(itemFee)!
                listItems[selectedRow].itemURL = itemURL
            }
        }
        
        // 前画面を更新
        let preNC = self.presentingViewController as! UINavigationController
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! MainViewController
        preVC.calcTotalFee()
        preVC.mainTableView.reloadData()
        
        // ローディング処理 終了
        SVProgressHUD.dismiss()
        
        // 入力画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 入力値チェック
    func validateInputs(itemName: String, itemFee: String, itemURL: String) -> Bool {
        // 入力値が空の場合、DBに保存しない
        if itemName.isEmpty {
            present(.okAlert(title: "入力エラー", message: "名前を入力してください。"))
            return false
        } else if itemFee.isEmpty {
            present(.okAlert(title: "入力エラー", message: "金額を入力してください。"))
            return false
        }
        
        // 金額の入力値が数値ではない場合、DBに保存しない
        if itemFee.isOnlyNumber == false {
            present(.okAlert(title: "入力エラー", message: "金額欄は数値のみ入力してください。"))
            return false
        }
        
        // URLが適切でない場合、DBに保存しない
        if itemURL.isEmpty == false && itemURL.isUrl == false {
            present(.okAlert(title: "入力エラー", message: "正しい形式のURLを入力してください。"))
            return false
        }
    
        return true
    }
    
    // キャンセルボタン タップ
    @IBAction func tappedCancelButton(_ sender: Any) {
        
        // 入力値が存在する場合、アラートを表示
        if nameTextField.text != beforeName || feeTextField.text != beforeFee {
            present(.okOrCancelAlert(title: "確認", message: "変更が保存されませんが、画面を閉じてよろしいですか？", handler: { _ in
                // 入力画面を閉じる
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            // 入力画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // TexitField編集開始時
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 編集中のTextFieldを保持
        activeTextField = textField
        return true
    }
    
    // Returnキー タップ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            feeTextField.becomeFirstResponder()
        } else {
            // キーボードを閉じる
            textField.resignFirstResponder()
        }
        return true
    }
    
    // キーボードを表示中に他の部分をタッチした際、キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Notification発行
        configureObserver()
    }
    
    // Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        // 編集中のキーボードを取得
        guard let textField = activeTextField else { return }
        
        // キーボードのCGrect（位置とサイズ)を取得
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) else { return }
        
        // TextFieldの下辺（VC基準のY座標＋TextFieldの高さ＋余白）
        let textFieldLimit = textField.frame.origin.y + (textField.frame.height) + 8.0
        
        // スクリーンの高さ
        let screenHeight = UIScreen.main.bounds.size.height
        // キーボードの高さ
        let keyboardHeight = rect.size.height
        // スクリーンの高さからキーボードの高さを引いた数値
        let keyboardLimit = screenHeight - keyboardHeight
        
        // 編集中のTextFieldの位置が、キーボードの位置より下の場合（隠れてしまった場合）
        if keyboardLimit <= textFieldLimit {
            // Duration（アニメーションの時間）を取得
            guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            // 画面の位置をキーボードの高さ分ずらす
            UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                self.view.transform = transform
            }
        }
    }
    
    // キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        // Duration（アニメーションの時間）を取得
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        
        // 画面の位置を戻す
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
}

//
//  Nanaco.swift
//  pNanaco
//
//  Created by 池田 洋平 on 2016/01/10.
//  Copyright © 2016年 IKEDA Youhey. All rights reserved.
//

import Foundation

/**
    nanaco の 会員メニュー Web サイトに関するモデル
 */
class Nanaco: NSObject {

    /// nanaco の 会員メニュー Web サイトのログインページ URL
    let loginUrl: String = "https://www.nanaco-net.jp/pc/emServlet"

    /**
        サイトへのログインを自動で実行するかフラグ

        - 0: なし
        - 1: カード記載の番号で自動ログイン
        - 2: 会員メニュー用パスワードで自動ログイン
    */
    var autoLogin: Int8 = 0

    /// nanaco 番号
    var nanacoId: String = ""

    /// カード記載の番号
    var securityNumber: String = ""

    /// 会員メニュー用パスワード
    var loginPassword: String = ""

    /// クレジットカードチャージのパスワード
    var chargePassword: String = ""

    /// ユーザの設定情報を読み込む
    func loadUserConfig() {
        let config: NSUserDefaults = self.buildUserConfig()

        self.autoLogin = Int8(config.integerForKey("autoLogin"))
        self.nanacoId = config.stringForKey("nanacoId")!
        self.securityNumber = config.stringForKey("securityNumber")!
        self.loginPassword = config.stringForKey("loginPassword")!
        self.chargePassword = config.stringForKey("chargePassword")!
    }

    /// ユーザの設定情報から ポータル nanaco の設定情報を組み立てる
    func buildUserConfig() ->NSUserDefaults {
        let appDefaults: Dictionary<String, AnyObject> = [
            "autoLogin": 0,
            "nanacoId": "",
            "securityNumber": "",
            "chargePassword": "",
            "loginPassword": ""
        ]

        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.registerDefaults(appDefaults)
        userDefaults.synchronize()

        return userDefaults
    }
}

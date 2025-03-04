//
//  PageOneViewModel.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/03/01.
//

import Foundation
import SwiftUI
import Alamofire

// APIレスポンスを保持するクラス
class PageOneViewModel: ObservableObject {
    let baseUrl = DataViewModel.Constants().baseUrl //リクエスト用URLの共通部分
    let apiKey = DataViewModel.Constants().difyAPIkey //APIキー
    
    
    struct DifySourceCode: Codable{
        let totalCalories:Double // 総摂取カロリー（kcal）
        let fat:Double // 脂質（mg）
        let carbohydrates:Double // 炭水化物および糖質（mg）
        let protein:Double // タンパク質（mg）
        let salt:Double // 塩分（mg）
        let vitaminC:Double // ビタミンC（mg）
        let vitaminD:Double // ビタミンD（mg）
        let otherVitamins:Double // その他ビタミン（mg）
        let minerals:Double // ミネラル（mg）
        let dietaryFiber:Double // 食物繊維（mg）
        let iron:Double // 鉄分（mg）
    }
}

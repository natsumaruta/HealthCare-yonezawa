//
//  PageOneView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//

import SwiftUI
import Alamofire
import Charts

struct PageOneView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var healthViewModel: HealthViewModel
    @ObservedObject var dataViewModel: DataViewModel
//    @EnvironmentObject var userData: UserData
    @Binding var dailyEnergy: Double
    @State private var message: String = ""

    
    //APIへリクエストしたり、レスポンスの値を保持するオブジェクト
    @StateObject private var PageOneVM = PageOneViewModel()
    
    @State var results : [String:Double] = ["totalCalories":0.0,"fat":0.0,"carbohydrates":0.0,"protein":0.0,"salt":0.0,"vitaminC":0.0,"vitaminD":0.0,"otherVitamins":0.0,"minerals":0.0,"dietaryFiber":0.0,"iron":0.0]
    let nutrients: [String: Int]
    let totalCalories: Int
    
//    init(viewModel: AuthViewModel, healthViewModel: HealthViewModel, dataViewModel: DataViewModel, userData: UserData, dailyEnergy: Double) {
//        self.viewModel = viewModel
//        self.healthViewModel = healthViewModel
//        self.dataViewModel = dataViewModel
//        self.nutrients = dataViewModel.totalNutrients
//        self.totalCalories = dataViewModel.totalNutrients["totalCalories"] ?? 0
//    }
    
    var body: some View {
        
        TabView{
            VStack{
                    Text("相棒の名前　:　ハチ助")
                    .padding()

                HStack{
                Text("　総トータルポイント：１００点")
                Spacer()
                Text("\(calculateDay())日目/７日間　") // 日数を表示
                    }.scaledToFit()
                Image(.ノーマル秋田犬)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                HStack{
                    Text("　あなたの　\n　推定１日\n　必要エネルギー量は \n 　\(dailyEnergy, specifier: "%.1f")Kcal")
                   
                    Chart {
                        BarMark(
                            x: .value("カテゴリ", "総摂取カロリー"),
                            y: .value("値", Double(totalCalories))
                        )
                        .foregroundStyle(.blue) // 棒グラフの色を調整

                        BarMark(
                            x: .value("カテゴリ", "目標摂取カロリー"),
                            y: .value("値", dailyEnergy)
                        )
                        .foregroundStyle(.orange) // 棒グラフの色を調整
                    }
                    .chartYScale(domain: 0...max(Double(totalCalories), dailyEnergy) + 100) // y軸の範囲を調整
                    .chartYAxis {
                        AxisMarks(values: .automatic) { value in
                            AxisValueLabel() {
                                if let intValue = value.as(Int.self) {
                                    Text("\(intValue) kcal")
                                }
                            }
                        }
                    }
                    .padding()
                }
                Chart {
                    ForEach(nutrientOrder, id: \.self) { name in
                        if let value = nutrients[name] {
                            BarMark(
                                x: .value("値", value),
                                y: .value("栄養素", localizedNutrientName(name))
                            )
                            .annotation(position: .trailing) { // グラフの値を左側に表示
                                Text("\(value)")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel(anchor: .trailing) { // 項目名を右側に表示
                            if let stringValue = value.as(String.self) {
                                Text(stringValue)
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
                .chartXScale(domain: 0...250) // グラフのスケールを調整
                .padding(.horizontal, 50) // パディングを調整
                .padding(.vertical, 10) // 上下のパディングを追加
                Button("Log Out") {
                    // ログアウトしてログイン画面へ遷移する
                    viewModel.signOut()
                }

            }
            
        }
    }
    let nutrientOrder: [String] = [ // 表示順序を定義
        "","fat", "carbohydrates", "protein", "salt",
        "vitaminC", "vitaminD", "otherVitamins", "minerals", "fiber", "iron"
    ]
    
    func localizedNutrientName(_ name: String) -> String {
        switch name {
        case "totalCalories": return "総摂取カロリー"
        case "fat": return "脂質"
        case "carbohydrates": return "炭水化物"
        case "protein": return "タンパク質"
        case "salt": return "塩分"
        case "vitaminC": return "ビタミンC"
        case "vitaminD": return "ビタミンD"
        case "otherVitamins": return "その他ビタミン"
        case "minerals": return "ミネラル"
        case "fiber": return "食物繊維"
        case "iron": return "鉄分"
        default: return name
        }
    }
    func incrementLoginCount() {
            let lastLoginDate = UserDefaults.standard.object(forKey: "lastLoginDate") as? Date
            let currentDate = Date()

            if let lastLoginDate = lastLoginDate, Calendar.current.isDate(lastLoginDate, inSameDayAs: currentDate) {
                return // すでにログイン済み
            }

            var loginCount = UserDefaults.standard.integer(forKey: "loginCount")
            loginCount += 1
            UserDefaults.standard.set(loginCount, forKey: "loginCount")
            UserDefaults.standard.set(currentDate, forKey: "lastLoginDate")
        }

        func calculateDay() -> Int {
            let loginCount = UserDefaults.standard.integer(forKey: "loginCount")
            return (loginCount % 7) + 1
        }
    func updateMessage() {
            let diff = dailyEnergy - Double(totalCalories)
            message = switch diff {
            case -200: "エネルギーオーバーしてるよ！"
            case -200: "エネルギーが少し多いよ！"
            case 0..<200: "エネルギーが少し足りないよ！"
            case 200...: "エネルギーが足りないよ！"
            default: ""
            }
        }
}

//    func requestNutritionData(){
//        let parameters:[String:Double] = ["totalCalories":0.0,"fat":0.0,"carbohydrates":0.0,"protein":0.0,"salt":0.0,"vitaminC":0.0,"vitaminD":0.0,"otherVitamins":0.0,"minerals":0.0,"fiber":0.0,"iron":0.0]
//        
//        AF.request(
//            baseUrl,
//            method:.get,
//            parameters: parameters
//        )


//    struct PageOneViewPreview: View {
//        @StateObject var viewModel = AuthViewModel()
//
//        var body: some View {
//            PageOneView(viewModel: viewModel)
//        }
//    }
//
//    #Preview {
//        PageOneViewPreview() // 別の `struct` で管理
//    }
//#Preview {
//    PageOneView(viewModel: AuthViewModel())
//}

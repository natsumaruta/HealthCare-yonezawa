//
//  PageThreeView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//

import SwiftUI

struct PageThreeView: View {
    @State private var weight: Double = 0.0 //TextField(weight)に入力した数値の変数
    @FocusState private var isFocused: Bool // フォーカスされているかの変数
    @State private var date:Date = Date()
    var body: some View {
        Form {
            Text("\(date)")
                .environment(\.locale, Locale(identifier: "ja_JP"))
            Section("体重"){
                HStack {
                    TextField("weight", value: $weight, format: .number)//数値のみ受け付ける入力場所
                        .keyboardType(.decimalPad)//数字・小数点のみキーボード
                        .focused($isFocused)
                    
                    Text("kg")
                }
            }
        }
    }
}

#Preview {
    PageThreeView()
}

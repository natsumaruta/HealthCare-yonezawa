//
//  BasicData.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/25.
//

import SwiftUI

struct PersonalData: View {
    @State private var name:String = "" //入力した名前の変数
    @State private var height: Double = 0.0 //TextField(height)に入力した数値の変数
    @State private var weight: Double = 0.0 //TextField(weight)に入力した数値の変数
    @State private var heightUnit = "cm" //単位Pickerで選択されたものを格納する変数
    @State private var gender = "男性" //性別Pickerで選択されたものを格納する変数
    @State private var birthDate = Calendar.current.date(from: DateComponents(year : 1985, month: 10, day: 1)) ?? Date()
    @State private var PhysicAlctivityLevel = "1日中ほとんど座っている"
    @State private var age:Int = 0 //
    @State private var showAlert = false //アラートの表示・非表示
    @FocusState private var isFocused: Bool // フォーカスされているかの変数
    
    let heightUnits = ["cm","m"]
    let genders =  ["男性","女性"]
    let PhysicAlctivityLevels = ["1日中ほとんど座っている","座って過ごす事が多いが、\n移動や立って行う作業、\n軽いスポーツなどをしている","移動や立って行う作業が多い、\nまたは活発にスポーツなどをしている"]
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("ニックネーム"){
                    TextField("name", text: $name)//ニックネームを受け付ける入力場所
                }
                VStack{
                    Picker("", selection: $gender) {
                        ForEach(genders, id: \.self) { unit in
                            Text(unit)
                        }
                    }.pickerStyle(.palette)
                }
                Section("生年月日"){
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                Section("年齢"){
                    HStack{
                        Text("\(age)")
                            .frame( alignment: .leading)
                    }
                    .onAppear{
                        age = toage(birthDate: birthDate)
                    }
                }
                Section("身長") {
                    HStack {
                        TextField("height", value: $height, format: .number)//数値のみ受け付ける入力場所
                            .keyboardType(.decimalPad)//数字・小数点のみキーボード
                        Picker("", selection: $heightUnit) {
                            ForEach(heightUnits, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                    }
                }
                .pickerStyle(.palette)
                Section("体重"){
                    HStack {
                        TextField("weight", value: $weight, format: .number)//数値のみ受け付ける入力場所
                            .keyboardType(.decimalPad)//数字・小数点のみキーボード
                            .focused($isFocused)
                        
                        Text("kg")
                    }
                }
                Section("活動レベル"){
                    Picker("", selection: $PhysicAlctivityLevel) {
                        ForEach(PhysicAlctivityLevels, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                }
            }
//            Section("BMI") {
//                HStack {
//                    Text(calculateBMI(heightUnit: "\(heightUnit)",height: height,weight:weight), format: .number.precision(.fractionLength(2)))
//                }
//            }
//            Section("BMI評価"){
//                HStack {
//                    let BMI: Double = calculateBMI(heightUnit: "\(heightUnit)",height: height,weight:weight)
//                    Text("\(checkFat(bmi:BMI))")
//                }
//            }
            Button {
                submitUserInfo()//ボタンが押されたら実行：登録の処理
            } label: {
                Text("登録")
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("ニックネームを入力してください", isPresented: $showAlert) {
            Text("OK")
        }
    }
    
    
    
    func calculateBMI(heightUnit: String,height: Double,weight:Double) -> Double{
        let metersheight = toMeters(oldUnit: "\(heightUnit)", value: height)
        return weight / (metersheight * metersheight)
    }
    
    
    //　長さの値をメートルに変換する関数
    func toMeters(oldUnit: String,value: Double) -> Double{
        switch oldUnit {
        case "m":
            return value
        case "cm":
            return value / 100
        default:
            return value
        }
    }
    // BMIの評価関数
    func checkFat(bmi:Double) -> String {
        if bmi < 18.5 {
            return "やせ"
        }else if bmi >= 18.5 && bmi < 25.0 {
            return "標準"
        }else if bmi >= 25{
            return "太り過ぎ"
        }else {
            return " "
        }
    }
    
    // 年齢の計算関数
    func toage(birthDate:Date) -> Int{
        let calendar = Calendar(identifier: .gregorian)
        let BirthDate = birthDate
        let now =  Date()
        let age = calendar.dateComponents([.year], from: BirthDate, to: now).year!
        return age
    }
    
    //ユーザー情報を登録する処理
    func submitUserInfo(){
        //名前が入力されているかチェック
        if name.isEmpty{
            showAlert = true //trueのときアラートを表示
            return
        }
    }
    
}

#Preview {
    PersonalData()
}

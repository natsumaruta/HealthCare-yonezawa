//
//  BasicData.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/25.
//

import SwiftUI

class UserData: ObservableObject {
    @Published var dailyEnergy: Double = 0.0
}

struct PersonalData: View {
    @State private var name: String = ""
    @State private var height: Double = 0.0
    @State private var weight: Double = 0.0
    @State private var heightUnit = "cm"
    @State private var gender = "男性"
    @State private var birthDate = Calendar.current.date(from: DateComponents(year: 1985, month: 10, day: 1)) ?? Date()
    @State private var PhysicAlctivityLevel = "1日中ほとんど座っている"
    @State private var age: Int = 0
    @State private var showAlert = false
//    @State private var dailyEnergy: Double = 0.0
    @FocusState private var isFocused: Bool
    @State private var bodyFatPercentage: Double = 0.0
    @State private var leanBodyMass: Double = 0.0
    @State private var proteinIntakeG: Double = 0.0
    @State private var proteinIntakeKcal: Double = 0.0
    @State private var fatIntakeG: Double = 0.0
    @State private var fatIntakeKcal: Double = 0.0
    @State private var carbIntakeG: Double = 0.0
    @State private var carbIntakeKcal: Double = 0.0
    @ObservedObject var userData = UserData()
//    @State var nutrientsArray:[dailyEnergy] = []
    
    @Binding var dailyEnergy: Double

    let heightUnits = ["cm", "m"]
    let genders = ["男性", "女性"]
    let PhysicAlctivityLevels = ["1日中ほとんど座っている", "座って過ごす事が多いが、\n移動や立って行う作業、\n軽いスポーツなどをしている", "移動や立って行う作業が多い、\nまたは活発にスポーツなどをしている"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("ニックネーム") {
                    TextField("name", text: $name)
                }
                VStack {
                    Picker("", selection: $gender) {
                        ForEach(genders, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.palette)
                }
                Section("生年月日") {
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                Section("身長") {
                    HStack {
                        TextField("height", value: $height, format: .number)
                            .keyboardType(.decimalPad)
                        Picker("", selection: $heightUnit) {
                            ForEach(heightUnits, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                    }
                    .pickerStyle(.palette)
                }
                Section("体重") {
                    HStack {
                        TextField("weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        Text("kg")
                    }
                }
                Section("活動レベル") {
                    Picker("", selection: $PhysicAlctivityLevel) {
                        ForEach(PhysicAlctivityLevels, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                }
                Section("1日の推定エネルギー量") {
                    HStack {
                        Text("\(dailyEnergy, specifier: "%.1f")")
                        Text("kcal")
                    }
                }
                Section("推定体脂肪率") {
                    HStack {
                        Text("\(bodyFatPercentage, specifier: "%.1f")%")
                    }
                }
                
                Section("PFCバランス") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("タンパク質")
                            Text("\(proteinIntakeG, specifier: "%.1f")g")
                            Text("(\(proteinIntakeKcal, specifier: "%.1f")kcal)")
                        }
                        HStack {
                            Text("脂質")
                            Text("\(fatIntakeG, specifier: "%.1f")g")
                            Text("(\(fatIntakeKcal, specifier: "%.1f")kcal)")
                        }
                        HStack {
                            Text("炭水化物")
                            Text("\(carbIntakeG, specifier: "%.1f")g")
                            Text("(\(carbIntakeKcal, specifier: "%.1f")kcal)")
                        }
                    }
                }
                
                //                Section("BMI") {
                //                    HStack {
                //                        Text(calculateBMI(), format: .number.precision(.fractionLength(2)))
                //                    }
                //                }
                //                Section("BMI評価") {
                //                    HStack {
                //                        Text(checkFat())
                //                    }
                //                }
                Button {
                    submitUserInfo()
                    
                } label: {
                    Text("登録")
                }
                .buttonStyle(.borderedProminent)
            }
            .onChange(of: birthDate) { _ in
                age = calculateAge()
                calculateEnergy()
            }
            .onChange(of: height) { _ in
                calculateEnergy()
            }
            .onChange(of: weight) { _ in
                calculateEnergy()
            }
            .onChange(of: gender) { _ in
                calculateEnergy()
            }
            .onChange(of: PhysicAlctivityLevel) { _ in
                calculateEnergy()
                userData.dailyEnergy = dailyEnergy // UserDataのdailyEnergyを更新
            }
            
            .onAppear {
                age = calculateAge()
                calculateEnergy()
                userData.dailyEnergy = dailyEnergy // UserDataのdailyEnergyを更新
            }
            .alert("ニックネームを入力してください", isPresented: $showAlert) {
                Text("OK")
            }
        }
    }

//    func addRegistration(value: Int){
//        let dailyEnergy = DailyEnergy(energy: value)
//        var array = nutrientsArray
//        array.append(task)
//        if let encodedData = try? JSONEncoder().encode(array) {
//            UserDefaults.standard.set(try? JSONEncoder().encode(dailyEnergy), forKey: "dailyEnergy")
//        }
//    }
    
    private func calculateBMI() -> Double {
        let metersHeight = toMeters(value: height)
        return weight / (metersHeight * metersHeight)
    }
    
    private func toMeters(value: Double) -> Double {
        switch heightUnit {
        case "m":
            return value
        case "cm":
            return value / 100
        default:
            return value
        }
    }
    
    private func checkFat() -> String {
        let bmi = calculateBMI()
        if bmi < 18.5 {
            return "やせ"
        } else if bmi >= 18.5 && bmi < 25.0 {
            return "標準"
        } else if bmi >= 25 {
            return "太り過ぎ"
        } else {
            return ""
        }
    }
    
    private func calculateAge() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        return calendar.dateComponents([.year], from: birthDate, to: now).year ?? 0
    }
    
    func submitUserInfo() {
        if name.isEmpty {
            showAlert = true
            return
        }
    }
    
    private func calculateEnergy() {
        let bmrTable: [String: [String: Double]] = [
            "男性": ["18-29": 24.0, "30-49": 22.3, "50-64": 21.5, "65-74": 21.5, "75↑": 21.5],
            "女性": ["18-29": 22.1, "30-49": 21.7, "50-64": 20.7, "65-74": 20.7, "75↑": 20.7]
        ]
        let palTable: [String: Double] = [
            "1日中ほとんど座っている": 1.5,
            "座って過ごす事が多いが、\n移動や立って行う作業、\n軽いスポーツなどをしている": 1.75,
            "移動や立って行う作業が多い、\nまたは活発にスポーツなどをしている": 2.0
        ]
        let ageGroup = getAgeGroup()
        guard let bmr = bmrTable[gender]?[ageGroup] else {
            dailyEnergy = 0
            return
        }
        let basalMetabolism = weight * bmr
        let pal = palTable[PhysicAlctivityLevel] ?? 1.5
        dailyEnergy = basalMetabolism * pal
    }
    
    private func getAgeGroup() -> String {
        switch age {
        case 18..<30: return "18-29"
        case 30..<50: return "30-49"
        case 50..<65: return "50-64"
        case 65..<75: return "65-74"
        default: return "75↑"
        }
    }
    // 追加する計算関数群
    // 体脂肪率計算（ロジック改善）
    private func calculateBodyFatPercentage() -> Double {
        guard weight > 0 else { return 0 }
        
        let heightInCm = heightUnit == "m" ? height * 100 : height
        var numerator: Double
        
        if gender == "男性" {
            numerator = 3.02 + 0.461 * weight - 6.85 - 0.089 * heightInCm + 0.038 * Double(age) - 0.238
        } else {
            numerator = 3.02 + 0.461 * weight - 0.089 * heightInCm + 0.038 * Double(age) - 0.238
        }
        
        let percentage = (numerator / weight) * 100
        return max(min(percentage, 100), 0)
    }
    
    private func calculatePFCBalance() {
        guard dailyEnergy > 0 else {
            resetPFCValues()
            return
        }
        
        // タンパク質
        proteinIntakeG = leanBodyMass * 2.5
        proteinIntakeKcal = proteinIntakeG * 4
        
        // 脂質（最低必要量を確保）
        fatIntakeKcal = max(dailyEnergy * 0.15, 0)
        fatIntakeG = max(fatIntakeKcal / 9, 0)
        
        // 炭水化物（残りのエネルギー）
        let remainingKcal = dailyEnergy - (proteinIntakeKcal + fatIntakeKcal)
        carbIntakeKcal = max(remainingKcal, 0)
        carbIntakeG = max(carbIntakeKcal / 4, 0)
    }
    private func resetPFCValues() {
        proteinIntakeG = 0
        proteinIntakeKcal = 0
        fatIntakeG = 0
        fatIntakeKcal = 0
        carbIntakeG = 0
        carbIntakeKcal = 0
    }
}
//
//#Preview {
//    PersonalData()
//}

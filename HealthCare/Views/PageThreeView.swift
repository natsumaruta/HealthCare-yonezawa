//
//  PageThreeView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//

import SwiftUI
import Charts

struct PageThreeView: View {
    @State private var weight: Double = 0.0
    @FocusState private var isFocused: Bool
    @State private var date: Date = Date()
    @State private var weightData: [Double] = []
    @State private var dateData: [Date] = []

    var body: some View {
        VStack {
            Form {
                Text("\(date)")
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                Section("体重") {
                    HStack {
                        TextField("weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        Text("kg")
                    }
                }
            }
            Button("体重登録") {
                saveWeightData()
            }
            .padding()
            Chart {
                ForEach(0..<weightData.count, id: \.self) { index in
                    LineMark(
                        x: .value("日付", dateData[index], unit: .day),
                        y: .value("体重", weightData[index])
                    )
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadWeightData()
        }
    }

    func saveWeightData() {
        weightData.append(weight)
        dateData.append(date)
        UserDefaults.standard.set(weightData, forKey: "weightData")
        UserDefaults.standard.set(dateData.map { $0.timeIntervalSince1970 }, forKey: "dateData")
    }

    func loadWeightData() {
        if let savedWeightData = UserDefaults.standard.array(forKey: "weightData") as? [Double],
           let savedDateData = UserDefaults.standard.array(forKey: "dateData") as? [TimeInterval] {
            weightData = savedWeightData
            dateData = savedDateData.map { Date(timeIntervalSince1970: $0) }
        }
    }
}

#Preview {
    PageThreeView()
}

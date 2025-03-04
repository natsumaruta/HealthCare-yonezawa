//
//  MainView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/25.
//

import SwiftUI


struct MainView: View {
    // タブの選択項目を保持する
    @State var selection = 1
//    @State private var showAlert = false //アラートの表示を制御
//    @State private var showImagePicker = false //ImagePickerの表示を制御
//    @State private var sourceType: UIImagePickerController.SourceType = .camera //画像の取得方法を指定する変数。初期値はカメラ
//    @State var mealImage: UIImage? //ImagePickerで取得した画像をいれる変数
    @StateObject var healthViewModel = HealthViewModel()
    @StateObject var dataViewModel = DataViewModel()
//    @EnvironmentObject var userData: UserData
    @State var dailyEnergy: Double = 0.0

    
    var viewModel: AuthViewModel
    
    var body: some View {

        TabView(selection: $selection) {
            
//            PageOneView(viewModel: viewModel, healthViewModel: healthViewModel, dataViewModel: dataViewModel, userData: userData, dailyEnergy: dailyEnergy)
            PageOneView(viewModel: viewModel, healthViewModel: healthViewModel, dataViewModel: dataViewModel, dailyEnergy: $dailyEnergy, nutrients: dataViewModel.totalNutrients, totalCalories: dataViewModel.totalNutrients["totalCalories"] ?? 0)
                .tabItem {
                    Label("Top", systemImage: "1.circle")
                }
                .tag(1)
            PageTwoView(healthViewModel: healthViewModel)   // Viewファイル①
                .tabItem {
                    Label("食事記録", systemImage: "2.circle")
                }
                .tag(2)
            
            PageThreeView()   // Viewファイル②
                .tabItem {
                    Label("体重記録", systemImage: "3.circle")
                }
                .tag(3)
            
           // PersonalData()  // Viewファイル③
            PersonalData(dailyEnergy: $dailyEnergy)  // Viewファイル③d
                .tabItem {
                    Label("設定", systemImage: "4.circle")
                }
                .tag(4)
        }

    }
}

#Preview {
    MainView(viewModel: AuthViewModel())
}

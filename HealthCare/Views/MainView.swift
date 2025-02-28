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
    @State private var showAlert = false //アラートの表示を制御
    @State private var showImagePicker = false //ImagePickerの表示を制御
    @State private var sourceType: UIImagePickerController.SourceType = .camera //画像の取得方法を指定する変数。初期値はカメラ
    @State var mealImage: UIImage? //ImagePickerで取得した画像をいれる変数
    
    var viewModel: AuthViewModel
    
    var body: some View {

        TabView(selection: $selection) {
            
            PageOneView()
                .tabItem {
                    Label("Top", systemImage: "1.circle")
                }
                .tag(1)
            PageTwoView()   // Viewファイル①
                .tabItem {
                    Label("食事記録", systemImage: "2.circle")
                }
                .tag(2)
                .onAppear {
                    // タブが表示されるタイミングでアラートを表示
                    if selection == 2 {
                        showAlert = true
                    }
                }
                .alert("食事を撮ろう", isPresented: $showAlert) {
                    Button("カメラ"){
                        sourceType = .camera //画像の取得方法（カメラ）を選択
                        showImagePicker = true
                        //ImagePickerの画面を表示
                    }
                    Button("フォトライブラリ"){
                        sourceType = .photoLibrary //画像の取得方法（フォトライブラリ）を選択
                        showImagePicker = true
                        //ImagePickerの画面を表示
                    }
                    Button("キャンセル"){
                    }
                    
                }
            
            PageThreeView()   // Viewファイル②
                .tabItem {
                    Label("体重記録", systemImage: "3.circle")
                }
                .tag(3)
            
            PersonalData()  // Viewファイル③
                .tabItem {
                    Label("設定", systemImage: "4.circle")
                }
                .tag(4)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $mealImage, sourceType: sourceType)
        }// TabView ここまで
    }
}

#Preview {
    MainView(viewModel: AuthViewModel())
}

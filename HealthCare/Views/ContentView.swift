//
//  ContentView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/23.
//

import SwiftUI

struct ContentView: View {
    // タブの選択項目を保持する
    @State var selection = 1
    @StateObject var dataViewModel = DataViewModel()
    @StateObject var userData = UserData()
    
    var viewModel: AuthViewModel
    
    var body: some View {
            
            VStack{
                Spacer()
                Text("みらいぬ")
                    .font(.title)
                    .frame(width: 200, height: 50)
            }
            VStack{
                Image(.dogAkitainu)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            VStack{
                NavigationStack {
                    NavigationLink(destination:LoginView(viewModel: AuthViewModel())) {
                        Text("ログイン")
                    }
                }
            }
            
        }
    }

#Preview {
    ContentView(viewModel: AuthViewModel())
}

//
//  PageOneView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//

import SwiftUI

struct PageOneView: View {
    
   
    
    var body: some View {
        //        VStack {
        //            Button("Log Out") {
        //                // ログアウトしてログイン画面へ遷移する
        //                viewModel.signOut()
        //            }
        //            .frame(alignment: .trailing)
        //        }
        TabView{
            VStack{
                Text("総トータルポイント")
                Text("相棒の名前:ハチ助")
                Spacer()
                Text("◯日目/７日間")
        
                Image(.dogAkitainu)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                Text("不足の栄養素")
                    .frame(alignment: .leading)

                Image(.graph10Oresen1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
    }
    
    //#Preview {
    //    PageOneView(viewModel: AuthViewModel())
    //}
}

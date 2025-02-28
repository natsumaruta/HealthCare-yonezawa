//
//  LoginView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel
    @State private var isNextViewPresented = false //次の画面の表示

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button {
                    login()
                }label:{
                    Text("SignIn")
                }
                .navigationDestination(isPresented: $isNextViewPresented) {
                    PersonalData()
                }

//                if viewModel.isAuthenticated {
//                    // ログイン後のページに遷移
//                    ContentView(viewModel: viewModel)
//                }

                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("Create Account")
                        .padding(.top, 16)
                }
                // パスワードのリセットページへ移動する
                NavigationLink(destination: ResetPasswordView(viewModel: viewModel)) {
                    Text("Password Reset")
                        .padding(.top, 16)
                }
            }
        }
    }
    //ログイン処理の関数
    func login(){
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            let user = authResult?.user
            print("Login User:",user ?? "NILL")
        }
    }
}
#Preview {
    LoginView(viewModel: AuthViewModel())
}

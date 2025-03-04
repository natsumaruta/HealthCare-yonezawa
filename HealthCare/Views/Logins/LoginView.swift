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
                Image(.喜び秋田犬)
                    .resizable()
                    .frame(width: 200, height: 200)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("サインイン"){
                    viewModel.signIn(email: email, password: password)
                }.buttonStyle(.borderedProminent)
//                .navigationDestination(isPresented: $isNextViewPresented) {
//                    PersonalData()
//                }
                .padding()
                
                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("新規登録")
                }
                .padding()
                .buttonStyle(.borderedProminent)
                // パスワードのリセットページへ移動する
                NavigationLink(destination: ResetPasswordView(viewModel: viewModel)) {
                    Text("パスワード再設定")
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
    //ログイン処理の関数
    func create(){
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            let user = authResult?.user
            print("Login User:",user ?? "NILL")
        }
    }
}
#Preview {
    LoginView(viewModel: AuthViewModel())
}

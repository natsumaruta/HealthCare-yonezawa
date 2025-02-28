//
//  ResetPasswordView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Reset Password") {
                viewModel.resetPassword(email: email)
            }
        }
    }
}
#Preview {
    ResetPasswordView(viewModel: AuthViewModel())
}

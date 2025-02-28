//
//  HealthCareApp.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HealthCareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            // ログイン状態によって画面遷移するページを変更する
                            if viewModel.isAuthenticated {
                                MainView(viewModel: viewModel)
                            } else {
                                LoginView(viewModel: viewModel)
                            }
        }
    }
}

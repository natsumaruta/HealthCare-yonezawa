//
//  PageTwoView.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/02/24.
//

//import SwiftUI
//import Alamofire
//import UIKit
//
//struct PageTwoView: View {
//    @State var postImage:UIImage?
//    @State private var showAlert = false //アラートの表示を制御
//    @State private var showImagePicker = false //ImagePickerの表示を制御
//    @State private var sourceType: UIImagePickerController.SourceType = .camera //画像の取得方法を指定する変数。初期値はカメラ
//    @State var mealImage: UIImage? //ImagePickerで取得した画像をいれる変数
//    @State var capturedImage: UIImage? // ImagePickerで取得した画像を入れる変数
//
//    var body: some View {
//        VStack{
//            Text("朝ご飯")
//            Image(.noimage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .onTapGesture {
//                    showAlert = true
//                }
//                .alert("食事を撮ろう", isPresented: $showAlert) {
//                    Button("カメラ"){
//                        sourceType = .camera //画像の取得方法（カメラ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("フォトライブラリ"){
//                        sourceType = .photoLibrary //画像の取得方法（フォトライブラリ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("キャンセル"){
//                    }
//                }
//            Text("昼ご飯")
//            Image(.noimage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .onTapGesture {
//                    showAlert = true
//                }
//                .alert("食事を撮ろう", isPresented: $showAlert) {
//                    Button("カメラ"){
//                        sourceType = .camera //画像の取得方法（カメラ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("フォトライブラリ"){
//                        sourceType = .photoLibrary //画像の取得方法（フォトライブラリ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("キャンセル"){
//                    }
//                }
//            Text("夜ご飯")
//            Image(.noimage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .onTapGesture {
//                    showAlert = true
//                }
//                .alert("食事を撮ろう", isPresented: $showAlert) {
//                    Button("カメラ"){
//                        sourceType = .camera //画像の取得方法（カメラ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("フォトライブラリ"){
//                        sourceType = .photoLibrary //画像の取得方法（フォトライブラリ）を選択
//                        showImagePicker = true
//                        //ImagePickerの画面を表示
//                    }
//                    Button("キャンセル"){
//                    }
//                }
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(image: $mealImage, sourceType: sourceType)
//        }// TabView ここまで
//
//    }
//}
//
//
//
//
//func uploadImageToDify(image: UIImage, userId: String) {
//    let url = "https://api.dify.ai/v1/files/upload"
//
//    // Authorization ヘッダーにBearerトークンを設定
//    let headers: HTTPHeaders = [
//        "Authorization": "Bearer app-mCEiB1I8e5clvJWZXpJ7UEwG"
//    ]
//
//    // 画像データの取得
//    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
//        print("画像データの変換に失敗しました")
//        return
//    }
//
//    // Alamofireを使ってmultipartフォームでアップロード
//    AF.upload(multipartFormData: { multipartFormData in
//        // 画像データをフォームデータに追加
//        multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
//
//        // ユーザーIDをフォームデータに追加
//        if let userData = userId.data(using: .utf8) {
//            multipartFormData.append(userData, withName: "user=abc-123")
//        }
//    }, to: url, method: .post, headers: headers)
//    .responseString { response in
//        switch response.result {
//        case .success(let value):
//            print("成功: \(value)")
//
//            if let statusCode = response.response?.statusCode {
//                if case 200...299 = statusCode {
//                    print("正常にアップロードされました")
//                } else {
//                    print("エラー発生: \(statusCode)")
//                    // 詳細なエラーメッセージを表示
//                    if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
//                        print("エラー内容: \(errorResponse)")
//                    }
//                }
//            }
//        case .failure(let error):
//            print("アップロード失敗: \(error.localizedDescription)")
//        }
//    }
//}
//
//#Preview {
//    PageTwoView()
//}

import SwiftUI
import Alamofire
import UIKit

struct PageTwoView: View {
    @State var postImage: UIImage?
    @State private var showAlert = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var mealImages: [UIImage?] = [nil, nil, nil]
    @State var capturedImage: UIImage?
    @State private var isUploading = false // アップロード中かどうかを管理
    @State private var uploadSuccess = false // アップロード成功かどうかを管理
    @State private var uploadError: String? // アップロードエラーメッセージを管理
    @ObservedObject var healthViewModel: HealthViewModel
    
    @State private var mealTime: Int = 0//各食事別
    
    var body: some View {
        VStack {
            Text("朝ご飯")
            Group{
                if let image = mealImages[0] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Image(.noimage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            .onTapGesture {
                mealTime = 0
                showAlert = true
            }
            
            Text("昼ご飯")
            Group{
                if let image = mealImages[1] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Image(.noimage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            .onTapGesture {
                mealTime = 1
                showAlert = true
            }
            Text("夜ご飯")
            Group{
                if let image = mealImages[2] {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Image(.noimage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            .onTapGesture {
                mealTime = 2
                showAlert = true
            }
            .alert("食事を撮ろう", isPresented: $showAlert) {
                Button("カメラ") {
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("フォトライブラリ") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("キャンセル") {}
            }
            
            // ... (昼ご飯、夜ご飯のセクションも同様に修正)
            
            if isUploading {
                Text("アップロード中...")
            } else if uploadSuccess {
                Text("アップロード成功！")
            } else if let error = uploadError {
                Text("アップロード失敗: \(error)")
                    .foregroundColor(.red)
            }
        }
    
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $mealImages[mealTime], sourceType: sourceType)
                .onDisappear {
                    if let image = mealImages[mealTime] {
                       // healthViewModel.nutrientdata[mealTime] = Constants().dummyData[mealTime]
                        uploadImageToDify(image: image, userId: "abc-123") // アップロード処理を呼び出し
                    }
                }
        }
    }
    
    func uploadImageToDify(image: UIImage, userId: String) {
        isUploading = true
        uploadSuccess = false
        uploadError = nil
        
        
        let uploadurl = "https://api.dify.ai/v1/files/upload"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer  \(DataViewModel.Constants().difyAPIkey) "
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("画像データの変換に失敗しました")
            uploadError = "画像データの変換に失敗しました"
            isUploading = false
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            if let userData = userId.data(using: .utf8) {
                multipartFormData.append(userData, withName: "user=abc-123")
            }
        }, to: uploadurl, method: .post, headers: headers)
        .responseDecodable(of:DifyUploadResponse.self) { response in
            isUploading = false
            switch response.result {
            case .success(let value):
                print("成功: \(value)")
                if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                    print("正常にアップロードされました")
                    uploadSuccess = true
                    // レスポンスの値を保持する変数に渡す
                    let response: DifyUploadResponse = value
                    postChatRequest(imageId: response.id)
                    
                } else {
                    print("エラー発生: \(response.response?.statusCode ?? 0)")
                    if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
                        print("エラー内容: \(errorResponse)")
                        uploadError = "エラーが発生しました: \(response.response?.statusCode ?? 0) \(errorResponse)"
                    } else {
                        uploadError = "不明なエラーが発生しました"
                    }
                }
            case .failure(let error):
                print("アップロード失敗: \(error.localizedDescription)")
                uploadError = "アップロードに失敗しました: \(error.localizedDescription)"
            }
        }
    }
    func postChatRequest(imageId: String) {
        let chatUrl = "https://api.dify.ai/v1/chat-messages"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(DataViewModel.Constants().difyAPIkey)", // Dify APIキーを設定
            "Content-Type": "application/json"
        ]
  
        
        // DifyChatRequest のインスタンスを作成
        let chatRequest = DifyChatRequest(
            inputs: DifyChatRequestInputs(mode: "カロリー計算"), // inputs の型を [String: Any] など適切に変更
            query: "画像について教えてください", // 適切なクエリを設定
            response_mode: "blocking", // 適切なレスポンスモードを設定
            conversation_id: "", // 適切な会話IDを設定
            user: "0534c82a-9963-40f5-bf92-6320a24705c1", // 適切なユーザーIDを設定
            files: [
                DifyChatRequestFiles(
                    type: "image",
                    transferMethod: "local_file",
                    uploadFileId: imageId // アップロードした画像のURLを設定
                )
            ]
        )
        
        // リクエストボディをJSONデータに変換
        guard let requestBody = try? JSONEncoder().encode(chatRequest) else {
            print("リクエストボディのエンコードに失敗しました")
            return
        }
        
        let parameters: [String: Any] = [
            "inputs": ["mode":"カロリー計算"],
            "query": "画像について教えてください",
            "response_mode": "blocking",
            "conversation_id": "",
            "user": "0534c82a-9963-40f5-bf92-6320a24705c1",
            "files": [
                [
                    "type": "image",
                    "transfer_method": "local_file",
                    "upload_file_id":  imageId
                ]
            ]
        ]
        
        // AF.request を使用してチャットリクエストを送信
        AF.request(chatUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("チャットリクエスト成功: \(json)")
                    // レスポンスの処理
                case .failure(let error):
                    print("チャットリクエスト失敗: \(error)")
                    // エラー処理
                }
            }
    }
}
//    func postChatRequest(imageid:String){
//
//        let chaturl = "https://api.dify.ai/v1/chat-messages"
//
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
//            if let userData = userId.data(using: .utf8) {
//                multipartFormData.append(userData, withName: "user=abc-123")
//            }
//        }, to: uploadurl, method: .post, headers: headers)
//        .responseDecodable(of:DifyUploadResponse.self) { response in
//            isUploading = false
//            switch response.result {
//            case .success(let value):
//                print("成功: \(value)")
//                if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
//                    print("正常にアップロードされました")
//                    uploadSuccess = true
//                    // レスポンスの値を保持する変数に渡す
//                    let response: DifyUploadResponse = value
//
//                } else {
//                    print("エラー発生: \(response.response?.statusCode ?? 0)")
//                    if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
//                        print("エラー内容: \(errorResponse)")
//                        uploadError = "エラーが発生しました: \(response.response?.statusCode ?? 0) \(errorResponse)"
//                    } else {
//                        uploadError = "不明なエラーが発生しました"
//                    }
//                }
//            case .failure(let error):
//                print("アップロード失敗: \(error.localizedDescription)")
//                uploadError = "アップロードに失敗しました: \(error.localizedDescription)"
//            }
//        }
//    }
//    }
//}



//#Preview {
//    PageTwoView()
//}

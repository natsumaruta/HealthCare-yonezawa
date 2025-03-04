//
//  DifyAPIModels.swift
//  HealthCare
//
//  Created by 米澤菜摘子 on 2025/03/01.
//

import Foundation

struct DifyInfo: Codable{
    let totalCalories:Int // 総摂取カロリー（kcal）
    let fat:Int // 脂質（mg）
    let carbohydrates:Int // 炭水化物および糖質（mg）
    let protein:Int // タンパク質（mg）
    let salt:Int // 塩分（mg）
    let vitaminC:Int // ビタミンC（mg）
    let vitaminD:Int // ビタミンD（mg）
    let otherVitamins:Int // その他ビタミン（mg）
    let minerals:Int // ミネラル（mg）
    let fiber:Int // 食物繊維（mg）
    let iron:Int // 鉄分（mg）
    
    // キャメルケース⇔スネークケースの相互変換するための記述
    enum CodingKeys: String, CodingKey {
        case totalCalories = "totalCalories"
        case fat = "fat"
        case carbohydrates = "carbohydrates"
        case protein = "protein"
        case salt = "salt"
        case vitaminC = "vitamin_c"
        case vitaminD = "vitamin_a"
        case otherVitamins = "vitamin_other"
        case minerals = "minerals"
        case fiber = "fiber"
        case iron = "iron"
        
    }
}

struct DifyUploadResponse: Codable{
    let id:String
    let name:String
    let size:Int
    let ext:String
    let mimeType:String
    let createdBy:String
    let createdAt:Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case size
        case ext = "extension"
        case mimeType = "mime_type"
        case createdBy = "created_by"
        case createdAt = "created_at"
//        "name": "example.png",
//        "size": 1024,
//        "extension": "png",
//        "mime_type": "image/png",
//        "created_by": "6ad1ab0a-73ff-4ac1-b9e4-cdb312f71f13",
//        "created_at": 1577836800
    }
}

struct DifyChatRequestInputs: Codable{
    let mode:String
}

struct DifyChatRequest: Codable{
    let inputs:DifyChatRequestInputs
    let query:String
    let response_mode:String
    let conversation_id:String
    let user:String
    let files:[DifyChatRequestFiles]
    
    enum CodingKeys: String, CodingKey {
        case inputs
        case query
        case response_mode
        case conversation_id
        case user
        case files
    }
}
//    "inputs": {},
//        "query": "iPhone 13 Pro Maxの仕様は何ですか？",
//        "response_mode": "streaming",
//        "conversation_id": "",
//        "user": "abc-123",
//        "files":
//    }'


    struct DifyChatRequestFiles: Codable{
        let type:String
        let transferMethod:String
        let uploadFileId:String
        
        enum CodingKeys: String, CodingKey {
            case type
            case transferMethod = "transfer_method"
            case uploadFileId = "upload_file_id"
        }
    }
//    "type": "image",
//    "transfer_method": "remote_url",
//    "url": "https://cloud.dify.ai/logo/logo-site.png"
//  }

